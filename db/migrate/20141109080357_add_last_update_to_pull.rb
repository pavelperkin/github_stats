class AddLastUpdateToPull < ActiveRecord::Migration
  def change
    add_column :pulls, :last_update, :datetime
  end
end
