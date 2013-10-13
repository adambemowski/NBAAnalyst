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

ActiveRecord::Schema.define(version: 20131013054113) do

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
    t.integer  "overunder_open"
    t.integer  "overunder_close"
    t.integer  "spread_open"
    t.integer  "spread_close"
    t.integer  "overunder_secondhalf"
    t.integer  "spread_secondhalf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
