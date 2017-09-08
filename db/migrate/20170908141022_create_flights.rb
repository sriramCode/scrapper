class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      t.string "name"
      t.string "source"
      t.string "destination"
      t.string "source_iata_code"
      t.string "destination_iata_code"
      t.text "dump"
      t.timestamps
    end
  end
end
