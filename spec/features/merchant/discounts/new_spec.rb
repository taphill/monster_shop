require 'rails_helper'

RSpec.describe "merchant/discounts/new", type: :feature do
  describe 'new discount form' do
    let!(:merchant) { create(:merchant) }
    let!(:user) { create(:user, role: 1, merchant: merchant) }

    before do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Login"

      visit new_merchant_discount_path
      fill_in 'Percentage', with: '5'
      fill_in 'Item quantity', with: '20'
      click_button 'Create'
    end

    it { expect(page).to have_current_path(merchant_discounts_path) }
    it { expect(page).to have_link("#{merchant.discounts[0].percentage}% discount on #{merchant.discounts[0].item_quantity} or more items")}
  end
end
