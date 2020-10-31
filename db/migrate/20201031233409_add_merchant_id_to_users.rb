class AddMerchantIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :merchant, default: 0
  end
end
