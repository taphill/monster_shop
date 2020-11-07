require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'can not see a link to merchant/discounts' do
      visit "/merchants/#{@bike_shop.id}"
      save_and_open_page
      expect(page).to_not have_link('Discounts Dashboard') 
    end
  end

  describe 'As a merchant' do
    context 'when I visit the bashboard' do
      it 'has a link to merchant/discounts' do
        merchant = create(:merchant)
        user = create(:user, role: 1, merchant: merchant)

        visit login_path
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button "Login"

        visit merchant_root_path

        click_link 'Discounts Dashboard'
        expect(page).to have_current_path(merchant_discounts_path)
      end
    end
  end
end
