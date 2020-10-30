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

    it "I can edit any/all of my profile data which is updated on my profile page" do
      user = create(:user)

      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      visit profile_path(user)

      click_link("Edit Profile Data")

      expect(current_path).to eq(profile_edit_path(user))

      expect(find_field(:name).value).to eq(user.name)
      expect(find_field(:street_address).value).to eq(user.street_address)
      expect(find_field(:city).value).to eq(user.city)
      expect(find_field(:state).value).to eq(user.state)
      expect(find_field(:zip).value).to eq(user.zip)
      expect(find_field(:email).value).to eq(user.email)
      expect(page).to_not have_field(:password)
      expect(page).to_not have_field(:password_confirmation)

      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80209"

      click_button "Update Profile"

      expect(current_path).to eq(profile_path)

      within ".user-profile" do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.street_address)
        expect(page).to have_content("Denver")
        expect(page).to have_content("CO")
        expect(page).to have_content("80209")
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.created_at.strftime("%m/%d/%Y"))
      end
    end

  end
end
