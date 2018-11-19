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

ActiveRecord::Schema.define(version: 20171207060152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_dates", force: :cascade do |t|
    t.integer "season_id"
    t.date    "date"
    t.index ["season_id"], name: "index_game_dates_on_season_id", using: :btree
  end

  create_table "periods", force: :cascade do |t|
    t.integer "game_id"
    t.integer "quarter"
    t.index ["game_id"], name: "index_periods_on_game_id", using: :btree
  end

  create_table "stat_joins", force: :cascade do |t|
    t.string  "model_type"
    t.integer "model_id"
    t.string  "interval_type"
    t.integer "interval_id"
    t.index ["interval_type", "interval_id"], name: "index_stat_joins_on_interval_type_and_interval_id", using: :btree
    t.index ["model_type", "model_id"], name: "index_stat_joins_on_model_type_and_model_id", using: :btree
  end

end
