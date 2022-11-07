class CreateParkingLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_levels do |t|
      t.references :garage, null: false, foreign_key: true
      t.string :name, null: false, limit: 12

      t.timestamps
    end
  end
end
