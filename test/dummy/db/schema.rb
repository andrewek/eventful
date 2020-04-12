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

ActiveRecord::Schema.define(version: 2020_04_12_190233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "eventful_events", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "description", default: "", null: false
    t.string "resource", default: "", null: false
    t.string "action", default: "", null: false
    t.jsonb "associations", default: "{}", null: false
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_eventful_events_on_action"
    t.index ["associations"], name: "index_eventful_events_on_associations", using: :gin
    t.index ["data"], name: "index_eventful_events_on_data", using: :gin
    t.index ["parent_id"], name: "index_eventful_events_on_parent_id"
    t.index ["resource"], name: "index_eventful_events_on_resource"
  end

end
