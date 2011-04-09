class AddStatusToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :status, :string, :null => false, :default => "new"
  end

  def self.down
    remove_column :items, :status
  end
end
