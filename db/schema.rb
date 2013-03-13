# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130313182645) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "ipns", :force => true do |t|
    t.float    "mc_gross"
    t.integer  "invoice"
    t.string   "protection_eligibility"
    t.string   "address_status"
    t.string   "payer_id"
    t.float    "tax"
    t.string   "address_street"
    t.datetime "payment_date"
    t.string   "payment_status"
    t.string   "charset"
    t.string   "address_zip"
    t.string   "first_name"
    t.float    "mc_fee"
    t.string   "address_country_code"
    t.string   "address_name"
    t.string   "notify_version"
    t.string   "custom"
    t.string   "payer_status"
    t.string   "address_country"
    t.string   "address_city"
    t.integer  "quantity"
    t.string   "verify_sign"
    t.string   "payer_email"
    t.string   "txn_id"
    t.string   "payment_type"
    t.string   "last_name"
    t.string   "address_state"
    t.string   "receiver_email"
    t.float    "payment_fee"
    t.string   "receiver_id"
    t.string   "txn_type"
    t.string   "item_name"
    t.string   "residence_country"
    t.boolean  "test_ipn"
    t.float    "handling_amount"
    t.string   "transaction_subject"
    t.float    "payment_gross"
    t.float    "shipping"
    t.string   "ipn_track_id"
    t.string   "mc_currency"
    t.string   "item_number"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "email"
    t.string   "currency"
    t.float    "amount"
    t.string   "token"
    t.string   "payer_id"
    t.string   "state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "province"
    t.string   "txn_id"
  end

  create_table "tickets", :force => true do |t|
    t.string   "name"
    t.float    "unit_price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
