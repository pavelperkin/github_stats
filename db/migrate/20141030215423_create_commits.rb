class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :user_id, null: false
      t.string :message, null: false
      t.string :url, null: false, unique: true
      t.string :sha, null: false, unique: true
      t.datetime :commited_at, null: false

      t.timestamps
    end
  end
end
