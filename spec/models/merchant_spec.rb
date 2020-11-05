require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
    it {should have_many(:orders).through(:items)}
  end

  describe 'instance methods' do
    describe '#no_orders?' do
      context 'when a merchant has no orders' do
        it 'returns false' do
          merchant = create(:merchant, :with_item_orders)
          expect(merchant.no_orders?).to eq(false)
        end
      end

      context 'when a merchant has orders' do
        it 'returns true' do
          merchant = build(:merchant)
          expect(merchant.no_orders?).to eq(true)
        end
      end
    end

    describe '#item_count' do
      it 'returns the total number of a merchants unqiue items' do
        merchant = create(:merchant, :with_items, item_count: 3)
        expect(merchant.item_count).to eq(3)
      end
    end

    describe '#average_item_price' do
      it 'returns the average item price a merchants items' do
        merchant = create(:merchant)
        create(:item, price: 4, merchant: merchant)
        create(:item, price: 2, merchant: merchant)
        create(:item, price: 6, merchant: merchant)

        expect(merchant.average_item_price).to eq(4)
      end
    end

    describe '#distinct_cities' do
      it 'returns array of unique city names from items ordered' do
        merchant = create(:merchant, :with_items)
        order1 = create(:order, city: 'Hershey')
        order2 = create(:order, city: 'Denver')
        order3 = create(:order, city: 'Denver')
        create(:item_order, item: merchant.items[0], order: order1)
        create(:item_order, item: merchant.items[0], order: order2)
        create(:item_order, item: merchant.items[0], order: order3)

        expected = ['Denver', 'Hershey']
        expect(merchant.distinct_cities.sort).to eq(expected.sort)
      end
    end

    describe '#enabled?' do
      context 'when merchant is enabled' do
        it 'returns true' do
          merchant = build(:merchant, enabled: true)
          expect(merchant.enabled?).to eq(true)
        end
      end

      context 'when merchant is disabled' do
        it 'returns false' do
          merchant = build(:merchant, enabled: false)
          expect(merchant.enabled?).to eq(false)
        end
      end
    end

    describe '#status' do
      context 'when merchant is enabled' do
        it "returns 'Enabled'" do
          merchant = build(:merchant, enabled: true)
          expect(merchant.status).to eq('Enabled')
        end
      end

      context 'when merchant is disabled' do
        it "returns 'Disabled'" do
          merchant = build(:merchant, enabled: false)
          expect(merchant.status).to eq('Disabled')
        end
      end
    end

    describe '#disable_items' do
      it 'disables all merchant items' do
        merchant = create(:merchant, :with_items, item_count: 3)

        merchant.disable_items
        expect(merchant.items[0].active?).to eq(false)
        expect(merchant.items[1].active?).to eq(false)
        expect(merchant.items[2].active?).to eq(false)
      end
    end

    describe '#enable_items' do
      it 'enables all merchant items' do
        merchant = create(:merchant)
        create_list(:item, 3, active?: false, merchant: merchant)

        merchant.enable_items
        expect(merchant.items[0].active?).to eq(true)
        expect(merchant.items[1].active?).to eq(true)
        expect(merchant.items[2].active?).to eq(true)
      end
    end

    describe '#pending_orders' do
      it 'returns pending orders for a merchant' do
        merchant = create(:merchant)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant)

        io_1 = create(:item_order, item: item_1)
        io_2 = create(:item_order, item: item_2)
        io_3 = create(:item_order, item: item_3)

        order_1 = io_1.order
        order_2 = io_2.order
        order_3 = io_3.order

        expected = [order_1, order_2, order_3]

        expect(merchant.pending_orders).to eq(expected)
      end

      it 'does not return orders that are not pending for a merchant' do
        merchant = create(:merchant)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant)
        order_1 = create(:order, status: 'packaged')

        io_1 = create(:item_order, item: item_1, order: order_1)
        io_2 = create(:item_order, item: item_2)
        io_3 = create(:item_order, item: item_3)

        order_2 = io_2.order
        order_3 = io_3.order

        expected = [order_2, order_3]

        expect(merchant.pending_orders).to eq(expected)
      end

      it 'does not return orders for other merchants' do
        merchant = create(:merchant)
        merchant_2 = create(:merchant)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant_2)

        io_1 = create(:item_order, item: item_1)
        io_2 = create(:item_order, item: item_2)
        io_3 = create(:item_order, item: item_3)

        order_1 = io_1.order
        order_2 = io_2.order
        order_3 = io_3.order

        expected = [order_1, order_2]
      end
    end
  end
end
