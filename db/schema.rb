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

ActiveRecord::Schema.define(version: 2022_06_13_232134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "address", limit: 50, null: false
    t.string "city", limit: 50, null: false
    t.string "zip", limit: 10, null: false
    t.string "country_code", limit: 50, null: false
    t.string "phone", limit: 15, null: false
    t.string "type", null: false
    t.bigint "user_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_account_id"], name: "index_addresses_on_user_account_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "author_books", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id", "book_id"], name: "index_author_books_on_author_id_and_book_id", unique: true
    t.index ["author_id"], name: "index_author_books_on_author_id"
    t.index ["book_id"], name: "index_author_books_on_book_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
  end

  create_table "book_materials", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "material_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_materials_on_book_id"
    t.index ["material_id"], name: "index_book_materials_on_material_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "year_publication"
    t.float "height"
    t.float "width"
    t.float "depth"
    t.float "price"
    t.integer "quantity"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "book_id", null: false
    t.integer "books_count", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_cart_items_on_book_id"
    t.index ["order_id"], name: "index_cart_items_on_order_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "books_count"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code", null: false
    t.integer "discount", null: false
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "materials", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_account_id"
    t.bigint "coupon_id"
    t.datetime "delivered_at", precision: 6
    t.datetime "in_delivery_at", precision: 6
    t.integer "state", default: 0
    t.string "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shipping_method_id"
    t.index ["coupon_id"], name: "index_orders_on_coupon_id"
    t.index ["shipping_method_id"], name: "index_orders_on_shipping_method_id"
    t.index ["user_account_id"], name: "index_orders_on_user_account_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "image_data"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title", null: false
    t.integer "rating", default: 0, null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "book_id", null: false
    t.bigint "user_account_id", null: false
    t.integer "status", default: 0
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_account_id"], name: "index_reviews_on_user_account_id"
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string "name", null: false
    t.string "days"
    t.float "price", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.boolean "use_billing_address", default: false
    t.index ["email"], name: "index_user_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_accounts_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "user_accounts"
  add_foreign_key "author_books", "authors"
  add_foreign_key "author_books", "books"
  add_foreign_key "book_materials", "books"
  add_foreign_key "book_materials", "materials"
  add_foreign_key "books", "categories"
  add_foreign_key "cart_items", "books"
  add_foreign_key "cart_items", "orders"
  add_foreign_key "orders", "coupons"
  add_foreign_key "orders", "shipping_methods"
  add_foreign_key "orders", "user_accounts"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "user_accounts"
end
