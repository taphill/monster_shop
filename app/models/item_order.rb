class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def self.unique_items
    select(:item_id).distinct.count
  end

  def subtotal
    price * quantity
  end
end
