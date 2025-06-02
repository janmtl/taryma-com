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

ActiveRecord::Schema[8.0].define(version: 2025_06_02_030403) do
  create_table "artworks", force: :cascade do |t|
    t.integer "catno"
    t.string "title", limit: 255
    t.date "date_created"
    t.integer "xinch"
    t.integer "yinch"
    t.integer "xcm"
    t.integer "ycm"
    t.boolean "recent"
    t.string "filename", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "category_id"
    t.integer "technique_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer "artwork_id"
    t.integer "study_id"
    t.string "position", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "image_attachments", force: :cascade do |t|
    t.integer "image_id"
    t.integer "study_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "filename", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "description", limit: 255
  end

  create_table "intro_slideshows", force: :cascade do |t|
    t.integer "artwork_id"
    t.integer "order"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "path", limit: 255
    t.integer "position"
    t.string "label", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "from", limit: 255
    t.string "email", limit: 255
    t.text "content"
    t.boolean "read"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "date_created"
  end

  create_table "page_attachments", force: :cascade do |t|
    t.integer "page_id"
    t.integer "image_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", limit: 255
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug", limit: 255
  end

  create_table "slides", force: :cascade do |t|
    t.integer "artwork_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "studies", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "techniques", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 255, null: false
    t.string "email", default: "", null: false
    t.string "crypted_password", limit: 255
    t.string "salt", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "remember_me_token", limit: 255
    t.datetime "remember_me_token_expires_at", precision: nil
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
