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

ActiveRecord::Schema[8.0].define(version: 2024_12_17_023644) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "country"
    t.string "state"
    t.string "postal_code"
    t.boolean "default"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "billing_histories", force: :cascade do |t|
    t.integer "subscription_id", null: false
    t.integer "amount_cents"
    t.string "currency"
    t.integer "event_type"
    t.datetime "event_date"
    t.text "metadata"
    t.integer "tax_amount_cents"
    t.integer "total_amount_cents"
    t.decimal "tax_rate", precision: 4, scale: 2
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_billing_histories_on_subscription_id"
    t.index ["user_id"], name: "index_billing_histories_on_user_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "price_cents"
    t.string "currency"
    t.integer "trial_duration_days"
    t.text "description"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "initial_subscription", default: false
    t.index ["initial_subscription"], name: "index_plans_on_initial_subscription", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "country"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "subscription_id"
    t.integer "user_id", null: false
    t.integer "amount_cents", default: 0
    t.integer "tax_amount_cents"
    t.decimal "tax_rate", precision: 4, scale: 2, default: "0.0"
    t.integer "total_amount_cents"
    t.string "currency"
    t.string "description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_purchases_on_subscription_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "status"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "trial_end_date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_id", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "theme", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "billing_histories", "subscriptions"
  add_foreign_key "billing_histories", "users"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "purchases", "subscriptions"
  add_foreign_key "purchases", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_settings", "users"
end
