require 'rails_helper'

RSpec.describe "As a visitor" do
  describe "When I visit a merchant show page" do
    it "I cannot delete a merchant" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

      visit "/merchants/#{bike_shop.id}"

      expect(page).to_not have_link("Delete Merchant")
    end
  end
end

RSpec.describe "As an admin" do
  describe "When I visit a merchant show page" do
    before(:each) do
      visit login_path
      admin = create(:user, role: 2)
      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button "Login"
      visit admin_merchants_path
    end

    it "I can delete a merchant that has items" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      visit "/merchants/#{bike_shop.id}"
      expect(page).to_not have_link("Delete Merchant")
    end
  end
end
