require 'rails_helper'

RSpec.describe "merchant/discounts/show", type: :feature do
  describe 'as a merchant' do
    let!(:merchant) { create(:merchant, :with_discounts, discount_count: 3) }
    let!(:user) { create(:user, role: 1, merchant: merchant) }

    before do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Login"

      visit merchant_discount_path(merchant.discounts[0])
    end

    it 'can get to the edit discount page' do
      click_link 'Edit Discount'
      expect(page).to have_current_path(edit_merchant_discount_path(merchant.discounts[0]))
    end
  end
end
