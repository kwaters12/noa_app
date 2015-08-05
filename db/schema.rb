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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150803164444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brokerages", force: :cascade do |t|
    t.string   "name"
    t.string   "postal_code"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "brokers", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "broker_type"
    t.integer  "sub_brokerage_id"
    t.integer  "brokerage_id"
  end

  add_index "brokers", ["brokerage_id"], name: "index_brokers_on_brokerage_id", using: :btree
  add_index "brokers", ["sub_brokerage_id"], name: "index_brokers_on_sub_brokerage_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sin"
    t.string   "dob"
    t.string   "email"
    t.string   "phone_num"
    t.integer  "broker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "pdf_path"
  end

  add_index "clients", ["broker_id"], name: "index_clients_on_broker_id", using: :btree

  create_table "dropbox_files", force: :cascade do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "url"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "noa_applications", force: :cascade do |t|
    t.string   "broker_first_name"
    t.string   "broker_last_name"
    t.string   "brokerage_name"
    t.string   "brokerage_phone_number"
    t.string   "brokerage_email"
    t.string   "referral_first_name"
    t.string   "referral_last_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "phone_num"
    t.string   "email"
    t.string   "sin"
    t.string   "dob"
    t.string   "noa_selection"
    t.boolean  "has_signature"
    t.boolean  "is_paid"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "broker_id"
    t.integer  "client_id"
    t.text     "notification_params"
    t.string   "status"
    t.datetime "purchased_at"
    t.string   "transaction_id"
    t.string   "pdf_path"
    t.string   "docusign_url"
  end

  add_index "noa_applications", ["broker_id"], name: "index_noa_applications_on_broker_id", using: :btree
  add_index "noa_applications", ["client_id"], name: "index_noa_applications_on_client_id", using: :btree

  create_table "phone_numbers", force: :cascade do |t|
    t.integer  "broker_id"
    t.integer  "client_id"
    t.string   "phone_number"
    t.string   "type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "phone_numbers", ["broker_id"], name: "index_phone_numbers_on_broker_id", using: :btree
  add_index "phone_numbers", ["client_id"], name: "index_phone_numbers_on_client_id", using: :btree

  create_table "sub_brokerages", force: :cascade do |t|
    t.string   "name"
    t.string   "postal_code"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "dropbox_session"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "broker_type"
    t.integer  "brokerage_id"
    t.integer  "sub_brokerage_id"
  end

  add_index "users", ["brokerage_id"], name: "index_users_on_brokerage_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["sub_brokerage_id"], name: "index_users_on_sub_brokerage_id", using: :btree

  add_foreign_key "noa_applications", "brokers"
  add_foreign_key "users", "brokerages"
  add_foreign_key "users", "sub_brokerages"
end
