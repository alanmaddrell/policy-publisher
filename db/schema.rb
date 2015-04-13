# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150409101217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "policies", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.text     "description"
    t.string   "content_id"
    t.text     "organisation_content_ids",                                array: true
    t.text     "people_content_ids",                                      array: true
    t.boolean  "england",                     default: true
    t.string   "england_policy_url"
    t.boolean  "northern_ireland",            default: true
    t.string   "northern_ireland_policy_url"
    t.boolean  "scotland",                    default: true
    t.string   "scotland_policy_url"
    t.boolean  "wales",                       default: true
    t.string   "wales_policy_url"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "policy_areas", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_id"
    t.text     "organisation_content_ids",                   array: true
    t.text     "people_content_ids",                         array: true
    t.boolean  "england",                     default: true
    t.string   "england_policy_url"
    t.boolean  "northern_ireland",            default: true
    t.string   "northern_ireland_policy_url"
    t.boolean  "scotland",                    default: true
    t.string   "scotland_policy_url"
    t.boolean  "wales",                       default: true
    t.string   "wales_policy_url"
  end

  add_index "policy_areas", ["content_id"], name: "index_policy_areas_on_content_id", unique: true, using: :btree
  add_index "policy_areas", ["name"], name: "index_policy_areas_on_name", unique: true, using: :btree
  add_index "policy_areas", ["slug"], name: "index_policy_areas_on_slug", unique: true, using: :btree

  create_table "policy_areas_programmes", force: :cascade do |t|
    t.integer  "policy_area_id"
    t.integer  "programme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programmes", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_id"
    t.text     "organisation_content_ids",                   array: true
    t.text     "people_content_ids",                         array: true
    t.boolean  "england",                     default: true
    t.string   "england_policy_url"
    t.boolean  "northern_ireland",            default: true
    t.string   "northern_ireland_policy_url"
    t.boolean  "scotland",                    default: true
    t.string   "scotland_policy_url"
    t.boolean  "wales",                       default: true
    t.string   "wales_policy_url"
  end

  add_index "programmes", ["content_id"], name: "index_programmes_on_content_id", unique: true, using: :btree
  add_index "programmes", ["name"], name: "index_programmes_on_name", unique: true, using: :btree
  add_index "programmes", ["slug"], name: "index_programmes_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "uid"
    t.string  "organisation_slug"
    t.string  "permissions"
    t.boolean "remotely_signed_out", default: false
    t.boolean "disabled",            default: false
  end

end
