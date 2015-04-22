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

ActiveRecord::Schema.define(version: 20150126020921) do

  create_table "bets", force: true do |t|
    t.string   "bet_type"
    t.string   "bet_place"
    t.integer  "range_money_line_from"
    t.integer  "range_money_line_to"
    t.integer  "range_over_under_from"
    t.integer  "range_over_under_to"
    t.integer  "range_spread_from"
    t.integer  "range_spread_to"
    t.integer  "win_percentage_from"
    t.integer  "win_percentage_to"
    t.integer  "win_percentage_games"
    t.string   "win_percentage_place"
    t.integer  "point_differential_from"
    t.integer  "point_differential_to"
    t.integer  "point_differential_games"
    t.string   "point_differential_place"
    t.integer  "timezones_traveled_from"
    t.integer  "timezones_traveled_to"
    t.integer  "timezones_traveled_games"
    t.integer  "win_percentage"
    t.integer  "return_per_bet"
    t.integer  "number_of_games"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "date"
    t.string   "visiting_team"
    t.integer  "visiting_1st"
    t.integer  "visiting_2nd"
    t.integer  "visiting_3rd"
    t.integer  "visiting_4th"
    t.integer  "visiting_score"
    t.integer  "visiting_moneyline"
    t.string   "home_team"
    t.integer  "home_1st"
    t.integer  "home_2nd"
    t.integer  "home_3rd"
    t.integer  "home_4th"
    t.integer  "home_score"
    t.integer  "home_moneyline"
    t.decimal  "overunder_open"
    t.decimal  "overunder_close"
    t.decimal  "spread_open"
    t.decimal  "spread_close"
    t.decimal  "overunder_secondhalf"
    t.decimal  "spread_secondhalf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "proper_date"
  end

end
