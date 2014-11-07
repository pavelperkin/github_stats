class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :body
      t.datetime :commented_at
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
