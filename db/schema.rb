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

ActiveRecord::Schema[7.0].define(version: 2023_05_11_132349) do
  # These are extensions that must be enabled in order to support this database

  create_table "custom_fields", force: :cascade do |t|
    t.bigint "form_id", null: false
    t.string "label", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.string "type", default: "Custom::StringField", null: false
    t.boolean "required", default: true, null: false
    t.json "options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_custom_fields_on_form_id"
    t.index ["type"], name: "index_custom_fields_on_type"
  end

  create_table "custom_forms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_response_fields", force: :cascade do |t|
    t.bigint "custom_form_id", null: false
    t.bigint "custom_field_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "custom_response_id", null: false
    t.index ["custom_field_id"], name: "index_custom_response_fields_on_custom_field_id"
    t.index ["custom_form_id"], name: "index_custom_response_fields_on_custom_form_id"
    t.index ["custom_response_id"], name: "index_custom_response_fields_on_custom_response_id"
  end

  create_table "custom_responses", force: :cascade do |t|
    t.bigint "custom_form_id", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_form_id"], name: "index_custom_responses_on_custom_form_id"
    t.index ["uuid"], name: "index_custom_responses_on_uuid", unique: true
  end

  add_foreign_key "custom_fields", "custom_forms", column: "form_id"
  add_foreign_key "custom_response_fields", "custom_fields"
  add_foreign_key "custom_response_fields", "custom_forms"
  add_foreign_key "custom_response_fields", "custom_responses"
  add_foreign_key "custom_responses", "custom_forms"
end
