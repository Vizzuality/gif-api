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

ActiveRecord::Schema.define(version: 20170316193559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "co_benefits_of_interventions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "co_benefits_of_interventions_projects", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "co_benefits_of_intervention_id"
    t.index ["project_id", "co_benefits_of_intervention_id"], name: "cbfp", unique: true, using: :btree
  end

  create_table "hazard_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hazard_types_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "hazard_type_id"
    t.index ["hazard_type_id"], name: "index_hazard_types_projects_on_hazard_type_id", using: :btree
    t.index ["project_id"], name: "index_hazard_types_projects_on_project_id", using: :btree
  end

  create_table "nature_based_solutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nature_based_solutions_projects", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "nature_based_solution_id"
    t.index ["project_id", "nature_based_solution_id"], name: "nbsp", unique: true, using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations_projects", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_organizations_projects_on_organization_id", using: :btree
    t.index ["project_id"], name: "index_organizations_projects_on_project_id", using: :btree
  end

  create_table "primary_benefits_of_interventions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "primary_benefits_of_interventions_projects", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "primary_benefits_of_intervention_id"
    t.index ["project_id", "primary_benefits_of_intervention_id"], name: "pbfp", unique: true, using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "project_uid"
    t.integer  "status"
    t.text     "name"
    t.string   "scale"
    t.float    "estimated_cost"
    t.float    "estimated_monetary_benefits"
    t.string   "original_currency"
    t.text     "summary"
    t.integer  "start_year"
    t.integer  "completion_year"
    t.string   "implementation_status"
    t.string   "intervention_type"
    t.text     "learn_more"
    t.text     "references"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "hazard_types_projects", "hazard_types"
  add_foreign_key "hazard_types_projects", "projects"
  add_foreign_key "organizations_projects", "organizations"
  add_foreign_key "organizations_projects", "projects"
end
