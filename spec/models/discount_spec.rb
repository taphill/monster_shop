# frozen_string_literal: true

require 'rails_helper'

describe Discount, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :percentage }
    it { is_expected.to validate_presence_of :item_quantity }
  end

  describe 'relationship' do
    it { is_expected.to belong_to :merchant }
  end

  describe 'instance methods' do
    describe '#valid_item_quantity' do
      context 'when a discount with a specific item_quanity does not already exist' do
        it 'returns true' do
          merchant = create(:merchant)
          discount1 = build(:discount, item_quantity: 3, merchant: merchant) 

          expect(discount1.valid_item_quantity?).to eq(true)
        end
      end

      context 'else' do
        it 'returns false' do
          merchant = create(:merchant)
          discount1 = create(:discount, item_quantity: 3, merchant: merchant) 
          discount2 = build(:discount, item_quantity: 3, merchant: merchant) 
      
          expect(discount2.valid_item_quantity?).to eq(false)
        end
      end
    end

    describe '#logical_discount?' do
      context 'when a disccount with a higher percentage and lower item threshold already exists' do
        it 'returns false' do
          merchant = create(:merchant)
          discount1 = create(:discount, percentage: 10, item_quantity: 5, merchant: merchant) 
          discount2 = build(:discount, percentage: 5, item_quantity: 15, merchant: merchant) 
          
          expect(discount2.logical_discount?).to eq(false)
        end
      end

      context 'else' do
        it 'returns true' do
          merchant = create(:merchant)
          discount1 = create(:discount, percentage: 10, item_quantity: 5, merchant: merchant) 
          discount2 = build(:discount, percentage: 15, item_quantity: 15, merchant: merchant) 
          
          expect(discount2.logical_discount?).to eq(true)
        end
      end
    end
  end
end
