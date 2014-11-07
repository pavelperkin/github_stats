class CreatePulls < ActiveRecord::Migration
  def change
    create_table :pulls do |t|
      t.integer :number
      t.string :state
      t.text :title
      t.string :url
      t.integer :user_id
      t.integer :repo_id

      t.timestamps
    end
  end
end
