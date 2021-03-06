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

ActiveRecord::Schema.define(version: 20150920020733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "playerturn",      default: "white"
    t.string   "title"
  end

  create_table "moves", force: true do |t|
    t.integer  "game_id"
    t.integer  "piece_id"
    t.integer  "x_coord"
    t.integer  "y_coord"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_x"
    t.integer  "old_y"
    t.boolean  "castle"
    t.boolean  "take"
  end

  add_index "moves", ["game_id"], name: "index_moves_on_game_id", using: :btree
  add_index "moves", ["piece_id"], name: "index_moves_on_piece_id", using: :btree

  create_table "pieces", force: true do |t|
    t.string   "piece_type"
    t.integer  "x_coord"
    t.integer  "y_coord"
    t.string   "color"
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_name"
  end

  add_index "pieces", ["game_id"], name: "index_pieces_on_game_id", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
