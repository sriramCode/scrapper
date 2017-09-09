class CreateTrains < ActiveRecord::Migration[5.1]
  def change
    create_table :trains do |t|
      t.string "name"
      t.string "source"
      t.string "destination"
      t.string "source_station_code"
      t.string "destination_station_code"
      t.text "dump"
      t.timestamps
    end
  end
end
