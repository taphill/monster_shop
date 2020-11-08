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

    it 'can see all bulk discounts as a link to its show page' do
      within "#discount-#{merchant.discounts[0].id}" do
        click_link "#{merchant.discounts[0].percentage}% discount on #{merchant.discounts[0].item_quantity} or more items"
        expect(page).to have_current_path(merchant_discount_path(merchant.discounts[0]))
      end

      visit merchant_discounts_path
      within "#discount-#{merchant.discounts[1].id}" do
        click_link "#{merchant.discounts[1].percentage}% discount on #{merchant.discounts[1].item_quantity} or more items"
        expect(page).to have_current_path(merchant_discount_path(merchant.discounts[1]))
      end

      visit merchant_discounts_path
      within "#discount-#{merchant.discounts[2].id}" do
        click_link "#{merchant.discounts[2].percentage}% discount on #{merchant.discounts[2].item_quantity} or more items"
        expect(page).to have_current_path(merchant_discount_path(merchant.discounts[2]))
      end
    end

    it 'can see link to create discount' do
      click_link 'Create New Discount'
      expect(page).to have_current_path(new_merchant_discount_path)
    end
  end
end
