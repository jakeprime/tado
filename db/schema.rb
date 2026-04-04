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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_161822) do
  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "current_temperature"
    t.string "name"
    t.boolean "power"
    t.integer "tado_id"
    t.float "tado_target_temperature"
    t.float "target_temperature"
    t.string "termination"
    t.datetime "updated_at", null: false
  end

  create_table "tado_tokens", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "refresh_token"
    t.datetime "updated_at", null: false
  end
end
