class AddProjectToOdts < ActiveRecord::Migration
  def self.up
    add_column :odts, :project_id, :string
  end

  def self.down
    remove_column :odts, :project_id
  end
end
