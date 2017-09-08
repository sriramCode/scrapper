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

ActiveRecord::Schema.define(version: 20170908141022) do

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "city_id"
    t.string "name"
    t.string "fullName"
    t.string "city_type"
    t.string "country"
    t.string "latitude"
    t.string "longitude"
    t.string "locationId"
    t.string "inEurope"
    t.string "countryId"
    t.string "countryCode"
    t.string "coreCountry"
    t.string "iata_airport_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "source"
    t.string "destination"
    t.string "source_iata_code"
    t.string "destination_iata_code"
    t.text "dump"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
