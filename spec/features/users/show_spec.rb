require 'rails_helper'

describe 'as a registered user' do
  before :each do
    @user = create(:user)
  end

  describe 'when I visit my profile page and have orders in system' do
    it 'has a link called my orders that takes me to /profile/orders' do
      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Login"
      expect(current_path).to eq(profile_path)

      click_on "My Orders"
      expect(current_path).to eq('/profile/orders')
    end
  end
end
