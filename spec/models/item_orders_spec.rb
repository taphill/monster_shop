require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :subtotal }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'class methods' do
    describe '.unique_items' do
      it "returns unique items for a merchant's item_orders" do
        merchant = create(:merchant, :with_items, item_count: 12)
        create(:item_order, item: merchant.items[2])
        create(:item_order, item: merchant.items[1])
        create(:item_order, item: merchant.items[3])
        create(:item_order, item: merchant.items[3])

        expect(ItemOrder.unique_items).to eq(3)
      end

      it "returns unique items for more than one merchant" do
        merchant = create(:merchant, :with_items, item_count: 3)
        merchant_2 = create(:merchant, :with_items, item_count: 4)

        create(:item_order, item: merchant.items[2])
        create(:item_order, item: merchant.items[1])
        create(:item_order, item: merchant.items[0])
        create(:item_order, item: merchant.items[0])
        create(:item_order, item: merchant_2.items[3])
        create(:item_order, item: merchant_2.items[3])
        create(:item_order, item: merchant_2.items[2])
        create(:item_order, item: merchant_2.items[1])

        expect(ItemOrder.unique_items).to eq(6)
      end
    end
  end

  describe 'instance methods' do
    describe '#discount_applied' do
      context 'when a discount was applied' do
        it 'return the discount percentage applied' do
          merchant = create(:merchant, :with_items, item_count: 3)
          item_order1 = create(:item_order, item: merchant.items[0], discount: 0.05)
          item_order2 = create(:item_order, item: merchant.items[1], discount: 0.10)
          item_order3 = create(:item_order, item: merchant.items[2])

          expect(item_order1.discount_applied).to eq(5)
          expect(item_order2.discount_applied).to eq(10)
          expect(item_order3.discount_applied).to be_nil
        end
      end
    end
  end
end
