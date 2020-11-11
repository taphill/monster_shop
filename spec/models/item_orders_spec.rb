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
end
