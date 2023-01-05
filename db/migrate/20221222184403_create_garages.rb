class CreateGarages < ActiveRecord::Migration[7.0]
  def change
    create_table :garages do |t|
      t.string :name
      t.string :address1, null: false
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.text :file

      t.timestamps
    end
  end
end
