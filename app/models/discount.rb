# frozen_string_literal: true

class Discount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, presence: true
  validates :item_quantity, presence: true

  def valid_item_quantity?
    Discount.where(item_quantity: self.item_quantity).empty?
  end

  def logical_discount?
    Discount.select(:percentage, :item_quantity)
            .where('item_quantity < ?', self.item_quantity)
            .where('percentage > ?', self.percentage)
            .empty?
  end
end
