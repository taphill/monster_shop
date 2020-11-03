require 'rails_helper'

RSpec.describe "As a merchant employee" do
  describe "When I visit the merchant items index page" do
    it "I see an edit button next to any item" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      user = create(:user, role: 1, merchant_id: meg.id)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: 'password'
      click_button "Login"

      visit "/merchant/items"

      within "#item-#{tire.id}" do
        expect(page).to have_content(tire.name)
        expect(page).to have_button("Edit")
        expect(page).to have_content("Price: $#{tire.price}")
        expect(page).to have_css("img[src*='#{tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(tire.description)
        expect(page).to have_content("Inventory: #{tire.inventory}")
      end
    end
  end

  describe "After clicking edit, I am taken to a form to edit the item's data" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @user = create(:user, role: 1, merchant_id: @meg.id)
      visit login_path
      fill_in :email, with: @user.email
      fill_in :password, with: 'password'
      click_button "Login"

      visit "/merchant/items"
      within "#item-#{@tire.id}" do
        click_on "Edit"
      end
    end

    it "is pre-populated with all the item's information" do
      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")
      expect(find_field(:item_name).value).to eq(@tire.name)
      expect(find_field(:item_price).value).to eq(@tire.price.to_s)
      expect(find_field(:item_description).value).to eq(@tire.description)
      expect(find_field(:item_image).value).to eq(@tire.image)
      expect(find_field(:item_inventory).value).to eq(@tire.inventory.to_s)
    end

    it "and I can change the data about the item" do
      fill_in :item_price, with: 120
      fill_in :item_description, with: "They'll never pop! Now with pop guarantee!"
      fill_in :item_inventory, with: 13

      click_on "Update Item"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item #{@tire.id} has been successfully updated!")

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_button("Edit")
        expect(page).to have_content("Price: $120.00")
        expect(page).to_not have_content("Price: $100.00")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content("They'll never pop! Now with pop guarantee!")
        expect(page).to have_content("Inventory: 13")
        expect(page).to_not have_content("Inventory: 12")

      end
    end

    it "and if I edit the image out, a placeholder takes its place" do
      fill_in :item_image, with: ""

      click_on "Update Item"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item #{@tire.id} has been successfully updated!")

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_button("Edit")
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='/images/image.png']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end
    end

    it 'I get a flash message if entire form is not filled out' do
      fill_in 'Name', with: ""
      fill_in 'Price', with: 110
      fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
      fill_in 'Image', with: ""
      fill_in 'Inventory', with: 11

      click_button "Update Item"

      expect(page).to have_content("Name can't be blank")
      expect(find_field(:item_name).value).to eq("")
      expect(find_field(:item_price).value).to eq("110")
      expect(find_field(:item_description).value).to eq("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
      expect(find_field(:item_image).value).to eq('/images/image.png')
      expect(find_field(:item_inventory).value).to eq("11")
    end
  end
end
