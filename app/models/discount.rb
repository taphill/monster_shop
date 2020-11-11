# frozen_string_literal: true

class Discount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, presence: true
  validates :item_quantity, presence: true

  def valid_item_quantity?
    Discount.where(item_quantity: self.item_quantity).empty?
  end

  def valid_percentage?
    Discount.where(percentage: self.percentage).empty?
  end

  def logical_discount?
    larger_discount_with_less_items? && smaller_discount_with_more_items?
  end

  private

  def larger_discount_with_less_items?
    Discount.select(:percentage, :item_quantity)
            .where('item_quantity < ?', self.item_quantity)
            .where('percentage > ?', self.percentage)
            .empty?
  end

  def smaller_discount_with_more_items?
    Discount.select(:percentage, :item_quantity)
            .where('item_quantity > ?', self.item_quantity)
            .where('percentage < ?', self.percentage)
            .empty?
  end
end
