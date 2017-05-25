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

ActiveRecord::Schema.define(version: 20170525112451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

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

  create_table "currencies", force: :cascade do |t|
    t.string "iso"
    t.string "name"
  end

  create_table "donors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donors_projects", force: :cascade do |t|
    t.integer  "donor_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donor_id"], name: "index_donors_projects_on_donor_id", using: :btree
    t.index ["project_id"], name: "index_donors_projects_on_project_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
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

  create_table "locations", force: :cascade do |t|
    t.string   "adm0_code"
    t.string   "adm0_name"
    t.string   "adm1_code"
    t.string   "adm1_name"
    t.string   "adm2_code"
    t.string   "adm2_name"
    t.string   "iso"
    t.integer  "level"
    t.string   "region"
    t.text     "centroid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations_projects", force: :cascade do |t|
    t.integer "location_id"
    t.integer "project_id"
    t.float   "latitude"
    t.float   "longitude"
    t.index ["location_id"], name: "index_locations_projects_on_location_id", using: :btree
    t.index ["project_id"], name: "index_locations_projects_on_project_id", using: :btree
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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "benefit_details"
    t.string   "slug"
    t.string   "contributor_name"
    t.string   "contributor_organization"
    t.text     "contact_info"
    t.string   "other_nature_based_solution"
    t.string   "other_primary_benefits_of_intervention"
    t.string   "other_co_benefits_of_intervention"
    t.integer  "user_id"
    t.string   "benefits_currency"
    t.float    "costs_usd"
    t.float    "benefits_usd"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "donors_projects", "donors"
  add_foreign_key "donors_projects", "projects"
  add_foreign_key "hazard_types_projects", "hazard_types"
  add_foreign_key "hazard_types_projects", "projects"
  add_foreign_key "locations_projects", "locations"
  add_foreign_key "locations_projects", "projects"
  add_foreign_key "organizations_projects", "organizations"
  add_foreign_key "organizations_projects", "projects"
end
