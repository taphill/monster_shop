class AddDiscountToItemOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :discount, :float
  end
end
