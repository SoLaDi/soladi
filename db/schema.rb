# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_08_214130) do

  create_table "bids", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.decimal "amount"
    t.integer "shares"
    t.boolean "contract_signed"
    t.integer "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_bids_on_membership_id"
    t.index ["start_date", "end_date", "membership_id"], name: "bids_unique", unique: true
  end

  create_table "distribution_points", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "housenumber"
    t.string "zipcode"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_distribution_points_on_person_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "distribution_point_id", null: false
    t.boolean "terminated", default: false, null: false
    t.index ["distribution_point_id"], name: "index_memberships_on_distribution_point_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "phone"
    t.integer "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "website_account_status"
    t.index ["membership_id"], name: "index_people_on_membership_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.date "entry_date"
    t.string "sender"
    t.string "description"
    t.decimal "amount"
    t.string "currency"
    t.string "status_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "membership_id"
    t.string "status", default: "ok", null: false
    t.index ["entry_date", "sender", "description", "amount", "currency"], name: "transactions_unique", unique: true
    t.index ["membership_id"], name: "index_transactions_on_membership_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "bids", "memberships"
  add_foreign_key "distribution_points", "people"
  add_foreign_key "memberships", "distribution_points"
  add_foreign_key "people", "memberships"
  add_foreign_key "transactions", "memberships"
end
