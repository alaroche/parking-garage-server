class CreateParkingRows < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_rows do |t|
      t.references :parking_level, null: false, foreign_key: true

      t.timestamps
    end
  end
end
