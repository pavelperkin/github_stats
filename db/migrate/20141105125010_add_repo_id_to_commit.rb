class AddRepoIdToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :repo_id, :integer, null: false
  end
end
