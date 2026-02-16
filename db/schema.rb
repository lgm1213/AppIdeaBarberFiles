# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_16_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "amount"
    t.integer "barber_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.string "status"
    t.string "stripe_charge_id"
    t.datetime "updated_at", null: false
    t.index ["barber_id"], name: "index_appointments_on_barber_id"
    t.index ["client_id"], name: "index_appointments_on_client_id"
    t.index ["status"], name: "index_appointments_on_status"
  end

  create_table "chairs", force: :cascade do |t|
    t.integer "barber_id"
    t.datetime "created_at", null: false
    t.boolean "is_available"
    t.string "name"
    t.integer "shop_id"
    t.datetime "updated_at", null: false
    t.index ["barber_id"], name: "index_chairs_on_barber_id"
    t.index ["shop_id"], name: "index_chairs_on_shop_id"
  end

  create_table "haircuts", force: :cascade do |t|
    t.integer "barber_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.text "details"
    t.datetime "updated_at", null: false
    t.index ["barber_id"], name: "index_haircuts_on_barber_id"
    t.index ["client_id"], name: "index_haircuts_on_client_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "low_stock_threshold", default: 10
    t.string "name", null: false
    t.integer "quantity", default: 0
    t.integer "reorder_cost_cents"
    t.bigint "shop_id", null: false
    t.string "sku"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.string "vendor_contact"
    t.string "vendor_name"
    t.index ["shop_id"], name: "index_inventory_items_on_shop_id"
  end

  create_table "shop_invitations", force: :cascade do |t|
    t.bigint "barber_id"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.datetime "expires_at", null: false
    t.bigint "invited_by_id", null: false
    t.text "message"
    t.string "role_type", default: "barber"
    t.bigint "shop_id", null: false
    t.string "status", default: "pending"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["barber_id"], name: "index_shop_invitations_on_barber_id"
    t.index ["invited_by_id"], name: "index_shop_invitations_on_invited_by_id"
    t.index ["shop_id"], name: "index_shop_invitations_on_shop_id"
    t.index ["token"], name: "index_shop_invitations_on_token", unique: true
  end

  create_table "shop_members", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "role_in_shop", default: "staff", null: false
    t.bigint "shop_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["shop_id", "user_id"], name: "index_shop_members_on_shop_id_and_user_id", unique: true
    t.index ["shop_id"], name: "index_shop_members_on_shop_id"
    t.index ["user_id"], name: "index_shop_members_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "address"
    t.integer "barber_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["barber_id"], name: "index_shops_on_barber_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.bigint "appointment_id"
    t.bigint "barber_id"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "shop_id", null: false
    t.date "transaction_date", null: false
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_transactions_on_appointment_id"
    t.index ["barber_id"], name: "index_transactions_on_barber_id"
    t.index ["shop_id"], name: "index_transactions_on_shop_id"
    t.index ["transaction_date"], name: "index_transactions_on_transaction_date"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.string "provider"
    t.string "role"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "users", column: "barber_id", on_delete: :cascade
  add_foreign_key "appointments", "users", column: "client_id", on_delete: :cascade
  add_foreign_key "chairs", "shops", on_delete: :cascade
  add_foreign_key "chairs", "users", column: "barber_id", on_delete: :nullify
  add_foreign_key "haircuts", "users", column: "barber_id", on_delete: :cascade
  add_foreign_key "haircuts", "users", column: "client_id", on_delete: :cascade
  add_foreign_key "inventory_items", "shops", on_delete: :cascade
  add_foreign_key "shop_invitations", "shops", on_delete: :cascade
  add_foreign_key "shop_invitations", "users", column: "barber_id", on_delete: :nullify
  add_foreign_key "shop_invitations", "users", column: "invited_by_id", on_delete: :cascade
  add_foreign_key "shop_members", "shops", on_delete: :cascade
  add_foreign_key "shop_members", "users", on_delete: :cascade
  add_foreign_key "shops", "users", column: "barber_id", on_delete: :cascade
  add_foreign_key "transactions", "appointments", on_delete: :nullify
  add_foreign_key "transactions", "shops", on_delete: :cascade
  add_foreign_key "transactions", "users", column: "barber_id", on_delete: :nullify
end
