class ItemOrder <ApplicationRecord
validates_presence_of :item_id, :order_id, :price, :quantity, :subtotal
  scope :fulfilled, -> { where('fulfill_status = ?', "fulfilled")}
  
  belongs_to :item
  belongs_to :order

  scope :fulfilled, -> { where('fulfill_status = ?', "fulfilled")}
  
  def self.unique_items
    select(:item_id).distinct.count
  end

  def discount_applied
    return nil if discount.nil?

    (discount * 100).to_i
  end
end
