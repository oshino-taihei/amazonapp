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

ActiveRecord::Schema.define(version: 20141214111222) do

  create_table "books", force: true do |t|
    t.string   "asin",       limit: 13
    t.string   "title"
    t.string   "url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["asin"], name: "index_books_on_asin", unique: true

  create_table "links", force: true do |t|
    t.string   "from_asin",  limit: 13
    t.string   "from_title"
    t.string   "to_asin",    limit: 13
    t.string   "to_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["from_asin", "to_asin"], name: "index_links_on_from_asin_and_to_asin", unique: true

end
