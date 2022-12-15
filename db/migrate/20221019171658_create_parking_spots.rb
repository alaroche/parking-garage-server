class CreateParkingSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_spots do |t|
      t.references :parking_level, null: false, foreign_key: true
      t.references :garage, null: false, foreign_key: true
      t.boolean :taken, null: false, default: false

      t.timestamps
    end
  end
end
