require 'rails_helper'

describe 'as a registered user' do
  describe 'when I visit my profile page and have orders in system' do
    it 'has a link called my orders that takes me to /profile/orders' do
      user = create(:user)

      visit profile_path
    end
  end
end
