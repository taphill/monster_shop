require 'rails_helper'

RSpec.describe "merchant/discounts/show", type: :feature do
  describe 'as a merchant' do
    let!(:merchant) { create(:merchant) }
    let!(:discount) { create(:discount, merchant: merchant) }
    let!(:user) { create(:user, role: 1, merchant: merchant) }

    before do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Login"

      visit merchant_discount_path(discount)
    end

    it 'can get to the edit discount page' do
      click_link 'Edit Discount'
      expect(page).to have_current_path(edit_merchant_discount_path(discount))
    end

    it 'can delete a discount' do
      click_button 'Delete Discount'
      expect(page).to have_current_path(merchant_discounts_path)
      expect(page).to_not have_content("#{discount.percentage}% discount on #{discount.item_quantity} or more items")
      expect(page).to have_content('Discount has been deleted')
    end
  end
end
