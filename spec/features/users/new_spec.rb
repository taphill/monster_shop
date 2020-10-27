require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  describe "I want to register as a user" do
    it "I can click on the register link in the nav bar and register as a user" do

      visit items_path

      within ".topnav" do
        click_link("Register")
      end

      expect(current_path).to eq("/register")

      fill_in :name, with: "Jun Lee"
      fill_in :street_address, with: "1234 America Lane"
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80017"
      fill_in :email, with: "jun.lee@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"

      click_button "Submit"

      user = User.last
      expect(user.name).to eq("Jun Lee")
      expect(user.email).to eq("jun.lee@gmail.com")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now registered and logged in!")

    end
  end

end
