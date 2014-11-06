class AddObservedToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :observed, :boolean, default:false
  end
end
