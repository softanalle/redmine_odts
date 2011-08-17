class CreateOdts < ActiveRecord::Migration
  def self.up
    create_table :odts do |t|
      t.column :filename, :string
      t.column :version, :integer
    end
  end

  def self.down
    drop_table :odts
  end
end
