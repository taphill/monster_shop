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

    context 'sad paths' do
      it 'can not create a discount with an existing item quantity' do
        create(:discount, percentage: 10, item_quantity: 20, merchant: merchant)

        visit new_merchant_discount_path
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: '20'
        click_button 'Create'
        
        expect(page).to have_content('A discount with 20 item(s) already exists')
      end

      it 'can not create a discount with an existing percentage' do
        create(:discount, percentage: 5, item_quantity: 10, merchant: merchant)

        visit new_merchant_discount_path
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: '20'
        click_button 'Create'
        
        expect(page).to have_content('A discount for 5% already exists')
      end

      it 'will show error if smaller discount with more items exists' do
        create(:discount, percentage: 10, item_quantity: 20, merchant: merchant)

        visit new_merchant_discount_path
        fill_in 'Percentage', with: '50'
        fill_in 'Item quantity', with: '5'
        click_button 'Create'

        expect(page).to have_content("This discount would make an existing discount invalid")
      end

      it 'will show error if larger discount with less items exists' do
        create(:discount, percentage: 10, item_quantity: 20, merchant: merchant)

        visit new_merchant_discount_path
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: '25'
        click_button 'Create'

        expect(page).to have_content("This discount would make an existing discount invalid")
      end

      it "percentage can't be blank" do
        visit new_merchant_discount_path
        fill_in 'Percentage', with: ' '
        fill_in 'Item quantity', with: '20'
        click_button 'Create'
        
        expect(page).to have_content("Percentage can't be blank")
      end

      it "item quantity can't be blank" do
        visit new_merchant_discount_path
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: ' '
        click_button 'Create'
        
        expect(page).to have_content("Item quantity can't be blank")
      end
    end
  end
end
