require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    describe "#add_item()" do
      it '.it will add an item that doesnt exits' do
        @cart.add_item(@hippo.id.to_s)

        expect(@cart.contents).to eq({
          @ogre.id.to_s => 1,
          @giant.id.to_s => 2,
          @hippo.id.to_s => 1
          })
      end

      it '.it will add an item that doesnt exits' do
        @cart.add_item(@ogre.id.to_s)

        expect(@cart.contents).to eq({
          @ogre.id.to_s => 2,
          @giant.id.to_s => 2,
          })
      end
    end

    it ".remove_one()" do
      @cart.remove_one(@giant.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 1
        })

      @cart.remove_one(@giant.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1
        })
    end

    it '.total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq({@ogre => 1, @giant => 2})
    end

    it '.total' do
      expect(@cart.total).to eq(120)
    end

    it '.inventory_check(item)' do
      expect(@cart.inventory_check(@giant)).to eq(false)
      expect(@cart.inventory_check(@ogre)).to eq(true)
    end
  end

  describe 'instance methods for discounts' do
    describe '#subtotal' do
      context 'when passed an item' do
        it 'returns the subtotal' do
          merchant = create(:merchant)
          item1 = create(:item, price: 20, merchant: merchant)
          item2 = create(:item, price: 50, merchant: merchant)
          discount = create(:discount, percentage: 5, item_quantity: 3, merchant: merchant)
          cart = Cart.new({
            item1.id.to_s => 2,
            item2.id.to_s => 4
            })

          expect(cart.subtotal(item1, 2)).to eq(40.0)
          expect(cart.subtotal(item2, 4)).to eq(190.0)
        end
      end
    end

    describe '#total' do
      it 'calculates all subtotals' do
        merchant = create(:merchant)
        item1 = create(:item, price: 20, merchant: merchant)
        item2 = create(:item, price: 50, merchant: merchant)
        discount = create(:discount, percentage: 5, item_quantity: 3, merchant: merchant)
        cart = Cart.new({
          item1.id.to_s => 2,
          item2.id.to_s => 4
          })

        expect(cart.total).to eq(230.0)
      end
    end

    describe '#present_discount_for' do
      context 'when an item in the cart has a discount' do
        it 'returns the discount percentage' do
          merchant = create(:merchant)
          item = create(:item, price: 50, merchant: merchant)
          discount = create(:discount, percentage: 5, item_quantity: 3, merchant: merchant)
          cart = Cart.new({
            item.id.to_s => 4
            })

          expect(cart.present_discount_for(item, 4)).to eq(5)
        end
      end

      context 'else' do
        it 'returns 0' do
          merchant = create(:merchant)
          item = create(:item, price: 50, merchant: merchant)
          discount = create(:discount, percentage: 5, item_quantity: 3, merchant: merchant)
          cart = Cart.new({
            item.id.to_s => 1
            })

          expect(cart.present_discount_for(item, 1)).to eq(0)
        end
      end
    end
  end
end
