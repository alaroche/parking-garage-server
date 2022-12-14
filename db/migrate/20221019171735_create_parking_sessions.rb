class CreateParkingSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_sessions do |t|
      t.references :parking_spot, null: false, foreign_key: true
      t.references :parking_level, null: false, foreign_key: true
      t.references :garage, null: false, foreign_key: true
      t.timestamp :started_at, null: false
      t.timestamp :stopped_at

      t.timestamps
    end
  end
end
