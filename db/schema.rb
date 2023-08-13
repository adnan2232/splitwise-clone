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

ActiveRecord::Schema.define(version: 2023_08_12_071321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expense_borrows", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "lender_id", null: false
    t.bigint "borrower_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["borrower_id"], name: "index_expense_borrows_on_borrower_id"
    t.index ["expense_id"], name: "index_expense_borrows_on_expense_id"
    t.index ["lender_id"], name: "index_expense_borrows_on_lender_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "created_by_id", null: false
    t.bigint "incurred_by_id", null: false
    t.date "exp_date", default: -> { "CURRENT_DATE" }, null: false
    t.text "description", default: "", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_expenses_on_created_by_id"
    t.index ["incurred_by_id"], name: "index_expenses_on_incurred_by_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.string "through", default: ""
    t.decimal "paid", precision: 10, scale: 2, null: false
    t.string "notes", default: ""
    t.bigint "lender_id", null: false
    t.bigint "borrower_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["borrower_id"], name: "index_transaction_histories_on_borrower_id"
    t.index ["lender_id"], name: "index_transaction_histories_on_lender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "mobile_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_accounts", force: :cascade do |t|
    t.bigint "lender_id", null: false
    t.bigint "borrower_id", null: false
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["borrower_id"], name: "index_users_accounts_on_borrower_id"
    t.index ["lender_id"], name: "index_users_accounts_on_lender_id"
  end

  add_foreign_key "expense_borrows", "expenses"
  add_foreign_key "expense_borrows", "users", column: "borrower_id"
  add_foreign_key "expense_borrows", "users", column: "lender_id"
  add_foreign_key "expenses", "users", column: "created_by_id"
  add_foreign_key "expenses", "users", column: "incurred_by_id"
  add_foreign_key "transaction_histories", "users", column: "borrower_id"
  add_foreign_key "transaction_histories", "users", column: "lender_id"
  add_foreign_key "users_accounts", "users", column: "borrower_id"
  add_foreign_key "users_accounts", "users", column: "lender_id"
end
