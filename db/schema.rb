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

ActiveRecord::Schema.define(version: 20141109080357) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "commented_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "commits", force: true do |t|
    t.integer  "user_id",         null: false
    t.text     "message",         null: false
    t.string   "url",             null: false
    t.string   "sha",             null: false
    t.datetime "commited_at",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "repo_id",         null: false
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "pulls", force: true do |t|
    t.integer  "number"
    t.string   "state"
    t.text     "title"
    t.string   "url"
    t.integer  "user_id"
    t.integer  "repo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_update"
  end

  create_table "repos", force: true do |t|
    t.string   "name",                            null: false
    t.string   "url",                             null: false
    t.integer  "organization_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "observed",        default: false
  end

  create_table "users", force: true do |t|
    t.integer  "github_id",  null: false
    t.string   "login",      null: false
    t.string   "url",        null: false
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
