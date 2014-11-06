class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.string :url, null: false, unique: true
      t.integer :organization_id, null: false

      t.timestamps
    end
  end
end
