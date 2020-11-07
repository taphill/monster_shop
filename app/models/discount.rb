# frozen_string_literal: true

class Discount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, presence: true
  validates :item_quantity, presence: true
end
