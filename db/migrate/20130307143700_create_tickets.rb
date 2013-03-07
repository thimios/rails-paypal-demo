class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.decimal :unit_price

      t.timestamps
    end
  end
end
