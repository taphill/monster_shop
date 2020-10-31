class RemoveMerchantIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :merchant, foreign_key: true
  end
end
