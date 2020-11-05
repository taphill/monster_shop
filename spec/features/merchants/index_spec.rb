require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I cannot see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to_not have_link("New Merchant")
    end

    it 'I cannot see a link to edit a new merchant' do
      visit '/merchants'
      click_on "Brian's Bike Shop"
      expect(page).to_not have_link("Update Merchant")
    end
  end

  describe 'As an Admin' do
    let!(:admin) { create(:user, role: 2) }
    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant, enabled: false) }

    before do
      visit login_path
      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button "Login"
      visit admin_merchants_path
    end

    context 'when a merchant is enabled' do
      it 'has a disable button' do
        within "#merchant-#{merchant1.id}" do
          expect(page).to have_button('Disable')
        end
      end

      it 'can disable an account' do
        within "#merchant-#{merchant1.id}" do
          click_button 'Disable'
        end

        expect(page).to have_current_path(admin_merchants_path)
        within "#merchant-#{merchant1.id}" do
          expect(page).to have_content('Disabled')
        end
      end

      it 'can see a flash message' do
        within "#merchant-#{merchant1.id}" do
          click_button 'Disable'
        end

        expect(page).to have_content("#{merchant1.name}'s account is now disabled")
      end
    end

    context 'when a merchant is disabled' do
      it 'has an enable button' do
        within "#merchant-#{merchant2.id}" do
          expect(page).to have_button('Enable')
        end
      end

      it ' can enable an account' do
        within "#merchant-#{merchant2.id}" do
          click_button 'Enable'
        end

        expect(page).to have_current_path(admin_merchants_path)
        within "#merchant-#{merchant2.id}" do
          expect(page).to have_content('Enabled')
        end
      end

      it 'can see a flash message' do
        within "#merchant-#{merchant2.id}" do
          click_button 'Enable'
        end

        expect(page).to have_content("#{merchant2.name}'s account is now enabled")
      end
    end
  end
end
