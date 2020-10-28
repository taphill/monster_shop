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

  describe 'when I login with bad credentials' do
    it 'redirects me to login page with flash message' do
      visit login_path

      user = create(:user)

      fill_in :email, with: user.email
      fill_in :password, with: 'password7'
      click_button 'Login'

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your login credentials were incorrect.")

      fill_in :email, with: "jun.lee@example.com"
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your login credentials were incorrect.")
    end
  end

  describe 'as a logged in user' do
    it 'redirects me to my dashboard/profile when I click login' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path
      expect(current_path).to eq("/profile")

      merchant = create(:user, role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      visit login_path
      expect(current_path).to eq("/merchant")

      admin = create(:user, role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit login_path
      expect(current_path).to eq("/admin")
    end
  end
end
