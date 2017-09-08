class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
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

      t.timestamps
    end
  end
end