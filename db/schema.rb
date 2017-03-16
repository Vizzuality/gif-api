# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170316155841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.integer  "project_uid"
    t.text     "name"
    t.float    "estimated_cost"
    t.float    "estimated_monetary_benefits"
    t.string   "original_currency"
    t.float    "primary_benefits_of_intervention"
    t.float    "cobenefits_of_intervention"
    t.text     "summary"
    t.integer  "start_year"
    t.integer  "completion_year"
    t.string   "implementation_status"
    t.text     "learn_more"
    t.text     "references"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

end
