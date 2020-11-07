require 'rails_helper'

RSpec.describe 'merchant/discounts', type: :feature do
  describe 'page layout' do
    let!(:merchant) { create(:merchant, :with_discounts, discount_count: 3) }
    let!(:user) { create(:user, role: 1, merchant: merchant) }

    before do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Login"
      visit merchant_discounts_path
    end

    it 'can see all bulk discounts' do
      within "#discount-#{merchant.discounts[0].id}" do
        expect(page).to have_link("#{merchant.discounts[0].percentage}")
        expect(page).to have_link("#{merchant.discounts[0].item_quantity}")
      end
    end
  end
end
