class AddFulfillStatusToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :fulfill_status, :string, default: "unfulfilled"
  end
end
