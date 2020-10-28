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
  end
end
