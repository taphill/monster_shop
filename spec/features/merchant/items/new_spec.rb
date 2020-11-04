require 'rails_helper'

RSpec.describe "As a merchant" do
  describe "When I visit the merchant items index page" do
    before(:each) do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      user = create(:user, role: 1, merchant_id: @brian.id)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: 'password'
      click_button "Login"
    end

    it 'I see a link to add a new item for that merchant' do
      visit "/merchant/items"

      expect(page).to have_link "Add New Item"
    end

    it 'I can add a new item by filling out a form' do
      visit "/merchant/items"

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@brian.name)
      expect(current_path).to eq("/merchant/items/new")

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq("/merchant/items")
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(Item.last.active?).to be(true)
      expect("#item-#{Item.last.id}").to be_present
      expect(page).to have_content(name)
      expect(page).to have_content("New item saved successfully!")
      expect(page).to have_content("Price: $#{new_item.price}")
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("Active")
      expect(page).to_not have_content(new_item.description)
      expect(page).to have_content("Inventory: #{new_item.inventory}")
    end

    it 'I can add an item without an image and get a placeholder' do
      visit "/merchant/items"

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@brian.name)
      expect(current_path).to eq("/merchant/items/new")
      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_css("img[src*='/images/image.png']")
    end

    it 'I get an alert if I dont fully fill out the form' do
      visit "/merchant/items"

      name = ""
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = ""

      click_on "Add New Item"

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
      expect(page).to have_button("Create Item")

      expect(find_field(:item_name).value).to eq(name)
      expect(find_field(:item_price).value).to eq(price.to_s)
      expect(find_field(:item_description).value).to eq(description)
      expect(find_field(:item_inventory).value).to eq(inventory)
    end

    it "I can't add a negative number to inventory" do
      visit "/merchant/items"

      name = "Chamois Buttr"
      price = -18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = -18

      click_on "Add New Item"

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Price must be greater than 0 and Inventory must be greater than 0")
      expect(page).to have_button("Create Item")

      expect(find_field(:item_name).value).to eq(name)
      expect(find_field(:item_price).value).to eq(price.to_s)
      expect(find_field(:item_description).value).to eq(description)
      expect(find_field(:item_inventory).value).to eq(inventory.to_s)
    end
  end
end
