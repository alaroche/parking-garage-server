class CreateGarages < ActiveRecord::Migration[7.0]
  def change
    create_table :garages do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state, limit: 2
      t.string :zip, limit: 5
      t.string :email

      t.timestamps
    end
  end
end
