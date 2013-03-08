class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.float :unit_price

      t.timestamps
    end
  end
end
