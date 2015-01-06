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

ActiveRecord::Schema.define(version: 20150106004255) do

  create_table "word_entries", force: :cascade do |t|
    t.string   "pos",        limit: 255
    t.integer  "word_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "word_entries", ["word_id"], name: "index_word_entries_on_word_id", using: :btree

  create_table "word_forms", force: :cascade do |t|
    t.integer  "word_entry_id",   limit: 4
    t.string   "text",            limit: 255
    t.string   "grammaticalType", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "word_forms", ["text"], name: "index_word_forms_on_text", using: :btree
  add_index "word_forms", ["word_entry_id"], name: "index_word_forms_on_word_entry_id", using: :btree

  create_table "word_meanings", force: :cascade do |t|
    t.integer  "word_entry_id", limit: 4
    t.string   "definition",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "word_meanings", ["word_entry_id"], name: "index_word_meanings_on_word_entry_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "lemma",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "word_entries", "words"
  add_foreign_key "word_forms", "word_entries"
  add_foreign_key "word_meanings", "word_entries"
end
