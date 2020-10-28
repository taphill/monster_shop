require 'rails_helper'

describe 'As a visitor' do
  describe 'when I login correctly' do
    it 'as a default user I am redirected to profile & see a flash message' do
      visit login_path

      user = create(:user)

      fill_in :email, with: user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}")
    end

    it 'as a merchant I am redirected to dashboard & see a flash message' do
      visit login_path

      merchant = create(:user, role: 1)

      fill_in :email, with: merchant.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Welcome, #{merchant.name}")
    end

    it 'as an admin I am redirected to dashboard & see a flash message' do
      visit login_path

      admin = create(:user, role: 2)

      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/admin")
      expect(page).to have_content("Welcome, #{admin.name}")
    end
  end
end
