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

ActiveRecord::Schema.define(version: 2021_02_22_183745) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "distribution_points", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "housenumber"
    t.string "zipcode"
    t.string "city"
    t.integer "contact_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.date "startDate"
    t.date "endDate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "distribution_point_id", null: false
    t.index ["distribution_point_id"], name: "index_memberships_on_distribution_point_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.decimal "amount"
    t.integer "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_payments_on_membership_id"
    t.index ["month", "year", "membership_id"], name: "payments_unique", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "phone"
    t.integer "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_people_on_membership_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.integer "shares"
    t.decimal "amount"
    t.integer "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_prices_on_membership_id"
    t.index ["year", "month", "membership_id"], name: "prices_unique", unique: true
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
    t.index ["entry_date", "sender", "description", "amount", "currency"], name: "transactions_unique", unique: true
    t.index ["membership_id"], name: "index_transactions_on_membership_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "distribution_points"
  add_foreign_key "payments", "memberships"
  add_foreign_key "people", "memberships"
  add_foreign_key "prices", "memberships"
  add_foreign_key "transactions", "memberships"
end
