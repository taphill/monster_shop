require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do
  describe "when I visit my show page" do
    it "I see my profile data except my password and a link to edit my data" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path(user)

      within ".user-profile" do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.street_address)
        expect(page).to have_content(user.city)
        expect(page).to have_content(user.state)
        expect(page).to have_content(user.zip)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.created_at.strftime("%m/%d/%Y"))
        expect(page).to have_link("Edit Profile Data")
        expect(page).to_not have_content(user.password)
      end

    end

  end
end
