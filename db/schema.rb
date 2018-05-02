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

ActiveRecord::Schema.define(version: 20180425033346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "bets", force: :cascade do |t|
    t.integer "game_id"
    t.string  "desc"
    t.integer "period"
    t.float   "away_prediction"
    t.float   "home_prediction"
    t.float   "away_score"
    t.float   "home_score"
    t.index ["game_id"], name: "index_bets_on_game_id", using: :btree
  end

  create_table "game_dates", force: :cascade do |t|
    t.integer "season_id"
    t.date    "date"
    t.index ["season_id"], name: "index_game_dates_on_season_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.integer "season_id"
    t.integer "away_team_id"
    t.integer "home_team_id"
    t.date    "date"
    t.index ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
    t.index ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
    t.index ["season_id"], name: "index_games_on_season_id", using: :btree
  end

  create_table "lines", force: :cascade do |t|
    t.integer "game_id"
    t.string  "desc"
    t.integer "period"
    t.float   "spread"
    t.float   "total"
    t.index ["game_id"], name: "index_lines_on_game_id", using: :btree
  end

  create_table "periods", force: :cascade do |t|
    t.integer "game_id"
    t.integer "quarter"
    t.index ["game_id"], name: "index_periods_on_game_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer "season_id"
    t.integer "team_id"
    t.string  "name"
    t.string  "abbr"
    t.string  "idstr"
    t.string  "position"
    t.index ["season_id"], name: "index_players_on_season_id", using: :btree
    t.index ["team_id"], name: "index_players_on_team_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year"
  end

  create_table "stat_joins", force: :cascade do |t|
    t.string  "model_type"
    t.integer "model_id"
    t.string  "interval_type"
    t.integer "interval_id"
    t.index ["interval_type", "interval_id"], name: "index_stat_joins_on_interval_type_and_interval_id", using: :btree
    t.index ["model_type", "model_id"], name: "index_stat_joins_on_model_type_and_model_id", using: :btree
  end

  create_table "stats", force: :cascade do |t|
    t.integer "season_id"
    t.integer "game_id"
    t.string  "model_type"
    t.integer "model_id"
    t.integer "games_back"
    t.boolean "season_stat",  default: false
    t.boolean "starter",      default: false
    t.integer "period"
    t.integer "sp",           default: 0
    t.integer "fgm",          default: 0
    t.integer "fga",          default: 0
    t.integer "thpa",         default: 0
    t.integer "thpm",         default: 0
    t.integer "fta",          default: 0
    t.integer "ftm",          default: 0
    t.integer "orb",          default: 0
    t.integer "drb",          default: 0
    t.integer "ast",          default: 0
    t.integer "stl",          default: 0
    t.integer "blk",          default: 0
    t.integer "tov",          default: 0
    t.integer "pf",           default: 0
    t.integer "pts",          default: 0
    t.float   "poss_percent", default: 0.0
    t.float   "pace",         default: 0.0
    t.float   "ortg",         default: 0.0
    t.float   "drtg",         default: 0.0
    t.index ["game_id"], name: "index_stats_on_game_id", using: :btree
    t.index ["model_type", "model_id"], name: "index_stats_on_model_type_and_model_id", using: :btree
    t.index ["season_id"], name: "index_stats_on_season_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.integer "season_id"
    t.string  "name"
    t.string  "abbr"
    t.string  "abbr2"
    t.string  "city"
    t.index ["season_id"], name: "index_teams_on_season_id", using: :btree
  end

end
