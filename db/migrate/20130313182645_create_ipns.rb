class CreateIpns < ActiveRecord::Migration
  def change
    create_table :ipns do |t|
      t.float :mc_gross
      t.integer :invoice
      t.string :protection_eligibility
      t.string :address_status
      t.string :payer_id
      t.float :tax
      t.string :address_street
      t.datetime :payment_date
      t.string :payment_status
      t.string :charset
      t.string :address_zip
      t.string :first_name
      t.float :mc_fee
      t.string :address_country_code
      t.string :address_name
      t.string :notify_version
      t.string :custom
      t.string :payer_status
      t.string :address_country
      t.string :address_city
      t.integer :quantity
      t.string :verify_sign
      t.string :payer_email
      t.string :txn_id
      t.string :payment_type
      t.string :last_name
      t.string :address_state
      t.string :receiver_email
      t.float :payment_fee
      t.string :receiver_id
      t.string :txn_type
      t.string :item_name
      t.string :residence_country
      t.boolean :test_ipn
      t.float :handling_amount
      t.string :transaction_subject
      t.float :payment_gross
      t.float :shipping
      t.string :ipn_track_id
      t.string :mc_currency
      t.string :item_number

      t.timestamps
    end
  end
end
