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
      context 'when a merchant discount with a specific item quanity does not already exist' do
        it 'returns true' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, item_quantity: 3, merchant: merchant1)
          discount2 = build(:discount, item_quantity: 5, merchant: merchant1)
          discount3 = create(:discount, item_quantity: 5, merchant: merchant2)

          expect(discount2.valid_item_quantity?).to eq(true)
        end
      end

      context 'else' do
        it 'returns false' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, item_quantity: 3, merchant: merchant1)
          discount2 = build(:discount, item_quantity: 3, merchant: merchant1)
          discount3 = create(:discount, item_quantity: 3, merchant: merchant2)

          expect(discount2.valid_item_quantity?).to eq(false)
        end
      end
    end

    describe '#valid_percentage?' do
      context 'when a merchant discount with a specific percentage already exists' do
        it 'returns false' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, percentage: 5, merchant: merchant1)
          discount2 = build(:discount, percentage: 5, merchant: merchant2)
          discount3 = create(:discount, percentage: 5, merchant: merchant2)

          expect(discount2.valid_percentage?).to eq(false)
        end
      end

      context 'else' do
        it 'returns true' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, percentage: 5, merchant: merchant1)
          discount2 = build(:discount, percentage: 10, merchant: merchant1)
          discount3 = create(:discount, percentage: 10, merchant: merchant2)

          expect(discount2.valid_percentage?).to eq(true)
        end
      end
    end

    describe '#logical_discount?' do
      context 'when a larger discount with less required items already exists' do
        it 'returns false' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, percentage: 10, item_quantity: 5, merchant: merchant1)
          discount2 = build(:discount, percentage: 5, item_quantity: 15, merchant: merchant1)
          discount3 = create(:discount, percentage: 5, item_quantity: 15, merchant: merchant2)

          expect(discount2.logical_discount?).to eq(false)
          expect(discount3.logical_discount?).to eq(true)
        end
      end

      context 'when a smaller discount with more required items already exists' do
        it 'returns false' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, percentage: 10, item_quantity: 5, merchant: merchant1)
          discount2 = build(:discount, percentage: 25, item_quantity: 1, merchant: merchant1)
          discount3 = create(:discount, percentage: 25, item_quantity: 1, merchant: merchant2)

          expect(discount2.logical_discount?).to eq(false)
          expect(discount3.logical_discount?).to eq(true)
        end
      end

      context 'else' do
        it 'returns true' do
          merchant1 = create(:merchant)
          merchant2 = create(:merchant)

          discount1 = create(:discount, percentage: 10, item_quantity: 5, merchant: merchant1)
          discount2 = build(:discount, percentage: 15, item_quantity: 15, merchant: merchant1)
          discount3 = create(:discount, percentage: 15, item_quantity: 15, merchant: merchant1)

          expect(discount2.logical_discount?).to eq(true)
        end
      end
    end
  end
end
