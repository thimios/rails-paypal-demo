class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :email
      t.string :currency
      t.float  :amount
      t.string :token
      t.string :payer_id

      t.string :state

      t.timestamps
    end
  end
end