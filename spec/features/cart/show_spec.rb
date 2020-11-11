require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        @discount = @mike.discounts.create(percentage: 10, item_quantity: 5)

        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it 'Next to each item is a way to increase the amount of that item' do
        ruler = @mike.items.create(name: "Ruler", description: "Measure away!", price: 1, image: "https://static6.depositphotos.com/1106005/640/i/450/depositphotos_6403604-stock-photo-wooden-ruler.jpg", inventory: 2)
        visit "/items/#{ruler.id}"
        click_on "Add To Cart"

        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_button('+')
          end
        end

        within "#cart-item-#{ruler.id}" do
          click_on '+'
          expect(page).to have_content("2")
          expect(page).to have_content("$2")
          expect(page).to_not have_button('+')
        end
      end

      it 'Next to each item is a way to decrease the amount of that item' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_button('+')
          end
        end

        within "#cart-item-#{@pencil.id}" do
          click_on '+'
          expect(page).to have_content("2")
          click_on '-'
          expect(page).to have_content("1")
          click_on '-'
        end

        expect(page).to_not have_content(@pencil.name)
      end

      context 'when an item qualifies for a discount' do
        it 'displays the discount percentage applied' do
          5.times do
            visit "/items/#{@pencil.id}"
            click_on "Add To Cart"
          end
          
          visit '/cart'
          within("#cart-item-#{@pencil.id}") do
            within("#cart-discount-#{@pencil.id}") do
              expect(page).to have_content('10%') 
            end
          end
        end
      end

      context 'when an item does not qualify for a discount' do
        it 'displays 0%' do
          visit '/cart'
          within("#cart-item-#{@pencil.id}") do
            within("#cart-discount-#{@pencil.id}") do
              expect(page).to have_content('0%') 
            end
          end
        end
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
