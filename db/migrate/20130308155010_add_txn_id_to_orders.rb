class AddTxnIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :txn_id, :string
  end
end
