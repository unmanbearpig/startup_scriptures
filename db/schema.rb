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

ActiveRecord::Schema.define(version: 20140607001707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden"
  end

  create_table "category_positions", force: true do |t|
    t.integer "category_id"
    t.integer "position"
  end

  add_index "category_positions", ["category_id"], name: "index_category_positions_on_category_id", using: :btree

  create_table "category_subcategory_positions", force: true do |t|
    t.integer "category_id"
    t.integer "subcategory_id"
    t.integer "position"
  end

  add_index "category_subcategory_positions", ["category_id"], name: "index_category_subcategory_positions_on_category_id", using: :btree
  add_index "category_subcategory_positions", ["subcategory_id"], name: "index_category_subcategory_positions_on_subcategory_id", using: :btree

  create_table "links", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.string   "author"
    t.integer  "score"
    t.boolean  "hidden"
    t.text     "description"
  end

  add_index "links", ["subcategory_id"], name: "index_links_on_subcategory_id", using: :btree

  create_table "promo_announcements", force: true do |t|
    t.integer  "link_id"
    t.string   "message"
    t.boolean  "is_visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  add_index "promo_announcements", ["link_id"], name: "index_promo_announcements_on_link_id", using: :btree

  create_table "saved_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saved_links", ["link_id"], name: "index_saved_links_on_link_id", using: :btree
  add_index "saved_links", ["user_id"], name: "index_saved_links_on_user_id", using: :btree

  create_table "subcategories", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden"
  end

  add_index "subcategories", ["category_id"], name: "index_subcategories_on_category_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_category_positions", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_category_positions", ["category_id"], name: "index_user_category_positions_on_category_id", using: :btree
  add_index "user_category_positions", ["user_id"], name: "index_user_category_positions_on_user_id", using: :btree

  create_table "user_category_subcategory_positions", force: true do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "subcategory_id"
    t.integer "position"
  end

  add_index "user_category_subcategory_positions", ["category_id"], name: "index_user_category_subcategory_positions_on_category_id", using: :btree
  add_index "user_category_subcategory_positions", ["subcategory_id"], name: "index_user_category_subcategory_positions_on_subcategory_id", using: :btree
  add_index "user_category_subcategory_positions", ["user_id"], name: "index_user_category_subcategory_positions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
