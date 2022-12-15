class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 50
      t.string :password_digest
      t.datetime :signed_in_at

      t.timestamps
    end
  end
end
