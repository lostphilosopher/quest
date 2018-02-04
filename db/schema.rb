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

ActiveRecord::Schema.define(version: 20180204071730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "description"
    t.integer  "level"
    t.integer  "value"
    t.string   "trait"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["game_id"], name: "index_challenges_on_game_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.integer  "progress",   default: 0
    t.integer  "points",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
  end

  create_table "officers", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "station"
    t.string   "name"
    t.integer  "cmd"
    t.integer  "eng"
    t.integer  "med"
    t.integer  "tac"
    t.integer  "sci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_officers_on_game_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ship"
    t.string   "name"
    t.string   "description"
    t.integer  "range"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "encoutering_challenge",             default: 70
    t.integer  "challenge_bump",                    default: 150
    t.integer  "failure_point_divisor",             default: 2
    t.integer  "retreat_points_divisor",            default: 1
    t.integer  "retreat_progress_cost",             default: 2
    t.integer  "officers_to_choose_from",           default: 10
    t.integer  "ships_to_choose_from",              default: 3
    t.integer  "refuel_countdown_hours",            default: 24
    t.integer  "max_fuel",                          default: 100
    t.integer  "max_shields",                       default: 100
    t.integer  "supply_min",                        default: 5
    t.integer  "supply_max",                        default: 10
    t.integer  "max_fuel_percentage_correction",    default: 1
    t.integer  "max_shields_percentage_correction", default: 1
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "ships", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.boolean  "commanded"
    t.integer  "cmd"
    t.integer  "eng"
    t.integer  "med"
    t.integer  "tac"
    t.integer  "sci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_ships_on_game_id", using: :btree
  end

  create_table "supplies", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "fuel"
    t.integer  "shields"
    t.integer  "cmd"
    t.integer  "eng"
    t.integer  "med"
    t.integer  "tac"
    t.integer  "sci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_supplies_on_game_id", using: :btree
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
    t.integer  "high_score"
    t.string   "high_score_ship"
    t.integer  "furthest_journey"
    t.string   "furthest_journey_ship"
    t.boolean  "admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
