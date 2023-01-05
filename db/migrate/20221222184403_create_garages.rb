class CreateGarages < ActiveRecord::Migration[7.0]
  def change
    create_table :garages do |t|
      t.text :file

      t.timestamps
    end
  end
end
