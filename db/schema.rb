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

ActiveRecord::Schema.define(version: 20150220134926) do

  create_table "cooperators", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "nickname"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cooperators", ["event_id"], name: "index_cooperators_on_event_id"
  add_index "cooperators", ["user_id"], name: "index_cooperators_on_user_id"

  create_table "events", force: true do |t|
    t.string   "name",                           null: false
    t.text     "short_description"
    t.text     "description"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slack",             default: "", null: false
    t.string   "payment_iban"
    t.string   "payment_bic"
    t.string   "payment_receiver"
    t.string   "company_name"
    t.text     "company_address"
  end

  create_table "images", force: true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "transfer_token"
    t.string   "validation_token"
    t.string   "state"
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["event_id"], name: "index_orders_on_event_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.float    "price"
    t.float    "tax"
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  add_index "products", ["event_id"], name: "index_products_on_event_id"

  create_table "sold_products", force: true do |t|
    t.integer  "product_id"
    t.string   "state"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verification_token"
    t.integer  "event_id"
    t.integer  "user_id"
  end

  add_index "sold_products", ["event_id"], name: "index_sold_products_on_event_id"
  add_index "sold_products", ["order_id"], name: "index_sold_products_on_order_id"
  add_index "sold_products", ["product_id"], name: "index_sold_products_on_product_id"
  add_index "sold_products", ["user_id"], name: "index_sold_products_on_user_id"

  create_table "users", force: true do |t|
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
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
