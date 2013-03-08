class AddProvinceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :province, :string
  end
end
