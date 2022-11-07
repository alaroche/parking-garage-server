class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :garage, null: false, foreign_key: true
      t.string :username, null: false, limit: 50
      t.string :salted_pswd, null: false
      t.datetime :signed_in_at

      t.timestamps
    end
  end
end
