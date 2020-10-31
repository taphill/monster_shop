require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it 'all images are links' do
      visit '/items'
      within "#item-#{@tire.id}" do
        click_link(href: "items/#{@tire.id}")
        expect(page).to have_current_path("/items/#{@tire.id}")
      end

      visit '/items'
      within "#item-#{@pull_toy.id}" do
        click_link(href: "items/#{@pull_toy.id}")
        expect(page).to have_current_path("/items/#{@pull_toy.id}")
      end

      visit '/items'
      within "#item-#{@dog_bone.id}" do
        click_link(href: "items/#{@dog_bone.id}")
        expect(page).to have_current_path("/items/#{@dog_bone.id}")
      end
    end

    it "I can see a list of all of the items "do
      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_link(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_content("Price: $#{@dog_bone.price}")
        expect(page).to have_content("Inactive")
        expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      end
    end

    it 'has statistics when there are enough unique item_orders' do
      merchant = create(:merchant, :with_items, item_count: 12)
      create(:item_order, item: merchant.items[2], quantity: 6)
      create(:item_order, item: merchant.items[1], quantity: 8)
      create(:item_order, item: merchant.items[3], quantity: 4)
      create(:item_order, item: merchant.items[0], quantity: 10)
      create(:item_order, item: merchant.items[4], quantity: 3)

      create(:item_order, item: merchant.items[5], quantity: 2)
      create(:item_order, item: merchant.items[6], quantity: 1)
      create(:item_order, item: merchant.items[7], quantity: 1)
      create(:item_order, item: merchant.items[8], quantity: 1)
      create(:item_order, item: merchant.items[9], quantity: 1)

      visit items_path

      within ".item-statistics" do
        within "#most-popular" do
          expect(page).to have_content(merchant.items[0].name)
          expect(page).to have_content(merchant.items[1].name)
          expect(page).to have_content(merchant.items[2].name)
          expect(page).to have_content(merchant.items[3].name)
          expect(page).to have_content(merchant.items[4].name)
        end

        within "#least-popular" do
          expect(page).to have_content(merchant.items[5].name)
          expect(page).to have_content(merchant.items[6].name)
          expect(page).to have_content(merchant.items[7].name)
          expect(page).to have_content(merchant.items[8].name)
          expect(page).to have_content(merchant.items[9].name)
        end
      end
    end

    it 'does not have statistics when there are not enough unique item_orders' do
      merchant = create(:merchant, :with_items, item_count: 12)
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])
      create(:item_order, item: merchant.items[2])

      visit items_path

      expect(page).to_not have_css('.item-statistics') 
    end
  end
end
