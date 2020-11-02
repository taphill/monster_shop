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

        expect(merchant.distinct_cities).to eq(['Denver', 'Hershey'])
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
  end
end
