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
    end

    context 'when successfully filled out' do
      it 'can create a new discount' do
        visit new_merchant_discount_path
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: '20'
        click_button 'Create'

        expect(page).to have_current_path(merchant_discounts_path)
        expect(page).to have_link("#{merchant.discounts[0].percentage}% discount on #{merchant.discounts[0].item_quantity} or more items")
        expect(page).to have_content('New discount successfully created')
      end
    end

    context 'when unsuccessfully filled out' do
      it 'can see flash error' do
        visit new_merchant_discount_path
        fill_in 'Percentage', with: ' '
        fill_in 'Item quantity', with: '20'
        click_button 'Create'
        
        expect(page).to have_content("Percentage can't be blank")
      end
    end
  end
end
