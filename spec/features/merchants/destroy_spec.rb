require 'rails_helper'

RSpec.describe "merchants/destroy", type: :feature do
  describe 'As a visitor' do
    context "When I visit a merchant show page" do
      it "cannot delete a merchant" do
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

        visit "/merchants/#{bike_shop.id}"

        expect(page).to_not have_link("Delete Merchant")
      end
    end
  end

  describe 'As a merchant' do
    context 'When I visit a merchant show page' do
      it 'cannot delete a merchant' do
        merchant1 = create(:merchant)
        merchant_user = create(:user, role: 1, merchant: merchant1)

        merchant2 = create(:merchant)
        visit login_path
        fill_in :email, with: merchant_user.email
        fill_in :password, with: 'password'
        click_button "Login"
        visit "/merchants/#{merchant2.id}"

        expect(page).to_not have_link('Delete Merchant')
      end
    end
  end

  describe "As an admin" do
    context "When I visit a merchant show page" do
      before(:each) do
        visit login_path
        admin = create(:user, role: 2)
        fill_in :email, with: admin.email
        fill_in :password, with: 'password'
        click_button "Login"
        visit admin_merchants_path
      end

      it "can delete a merchant that has items" do
        bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

        visit "/merchants/#{bike_shop.id}"
        expect(page).to_not have_link("Delete Merchant")
      end
    end
  end
end
