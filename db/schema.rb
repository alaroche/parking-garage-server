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

ActiveRecord::Schema[7.0].define(version: 2022_10_19_171735) do
  create_table "garages", force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state", limit: 2
    t.string "zip", limit: 5
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parking_levels", force: :cascade do |t|
    t.integer "garage_id", null: false
    t.string "name", limit: 12, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garage_id"], name: "index_parking_levels_on_garage_id"
  end

  create_table "parking_sessions", force: :cascade do |t|
    t.integer "parking_spot_id", null: false
    t.integer "parking_level_id", null: false
    t.integer "garage_id", null: false
    t.datetime "started_at", precision: nil, null: false
    t.datetime "stopped_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garage_id"], name: "index_parking_sessions_on_garage_id"
    t.index ["parking_level_id"], name: "index_parking_sessions_on_parking_level_id"
    t.index ["parking_spot_id"], name: "index_parking_sessions_on_parking_spot_id"
  end

  create_table "parking_spots", force: :cascade do |t|
    t.integer "parking_level_id", null: false
    t.integer "garage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garage_id"], name: "index_parking_spots_on_garage_id"
    t.index ["parking_level_id"], name: "index_parking_spots_on_parking_level_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 50, null: false
    t.string "password_digest"
    t.datetime "signed_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "parking_levels", "garages"
  add_foreign_key "parking_sessions", "garages"
  add_foreign_key "parking_sessions", "parking_levels"
  add_foreign_key "parking_sessions", "parking_spots"
  add_foreign_key "parking_spots", "garages"
  add_foreign_key "parking_spots", "parking_levels"
end
