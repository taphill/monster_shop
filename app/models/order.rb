class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status:  %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum(:subtotal)
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def status_check
    if all_fulfilled? && self.status != "packaged"
      update(:status => "packaged")
    end
    self.status
  end

  def all_fulfilled?
    item_orders.fulfilled.count == item_orders.count
  end

  def merchant_items(merchant_id)
    items.where('merchant_id = ?', merchant_id)
  end
end
