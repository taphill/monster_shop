class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status:  %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def status_check
    if all_fulfilled? && self.status != "packaged"
      self.status = "packaged"
      self.save
      self.status
    else
      self.status
    end
  end

  def all_fulfilled?
    item_orders.all? do |io|
      io.fulfill_status == "fulfilled"
    end
  end
end
