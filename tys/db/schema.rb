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

ActiveRecord::Schema.define(version: 20161117102858) do

  create_table "applications", force: :cascade do |t|
    t.string   "application_name",     limit: 255, null: false
    t.string   "author",               limit: 255, null: false
    t.string   "programming_language", limit: 255, null: false
    t.string   "github_repository",    limit: 255, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "authorization_token",  limit: 255, null: false
  end

  create_table "contributors", force: :cascade do |t|
    t.string   "user_id",        limit: 255, null: false
    t.integer  "application_id", limit: 4,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "contributors", ["user_id", "application_id"], name: "index_contributors_on_user_id_and_application_id", unique: true, using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.text     "text",           limit: 65535, null: false
    t.string   "feedback_type",  limit: 255,   null: false
    t.integer  "application_id", limit: 4,     null: false
    t.string   "email",          limit: 255
    t.string   "user_name",      limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "parent_id",      limit: 4
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "leader_name",    limit: 255, null: false
    t.string   "target_name",    limit: 255, null: false
    t.integer  "application_id", limit: 4,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "invite_token",   limit: 255, null: false
  end

  create_table "issues", id: false, force: :cascade do |t|
    t.integer  "github_number",     limit: 4
    t.integer  "stack_trace_id",    limit: 4,   null: false
    t.string   "github_repository", limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "stack_traces", force: :cascade do |t|
    t.integer  "application_id",      limit: 4,     null: false
    t.text     "stack_trace_text",    limit: 65535, null: false
    t.text     "stack_trace_message", limit: 65535, null: false
    t.string   "application_version", limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "fixed"
    t.datetime "crash_time",                        null: false
    t.string   "error_type",          limit: 255
    t.string   "device",              limit: 255
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "bio",             limit: 65535
    t.string   "secondary_email", limit: 255
    t.string   "phone",           limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
