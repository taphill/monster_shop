require 'rails_helper'

describe 'As a merchant employee' do
  describe 'when I log in and visit the merchant dashboard' do
    it "I see the name and full address of the merchant I work for" do
      merchant = create(:user, role:1)

      visit login_path

      fill_in :email, with: merchant.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq(merchant_path)

      within ".merchant-info" do
        expect(page).to have_content(merchant.name)
        expect(page).to have_content(merchant.street_address)
        expect(page).to have_content(merchant.city)
        expect(page).to have_content(merchant.state)
        expect(page).to have_content(merchant.zip)
      end

    end
  end
end
