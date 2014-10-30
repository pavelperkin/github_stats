class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :github_id, index: true, null: false, unique: true
      t.string :login, null: false, unique: true
      t.string :url, null: false, unique: true
      t.string :avatar_url, unique: true

      t.timestamps
    end
  end
end
