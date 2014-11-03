class AddOrganizationToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :organization_id, :integer
  end
end
