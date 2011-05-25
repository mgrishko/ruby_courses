class MovePrivatePropertyFromItemsToBaseItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :private
    add_column :base_items, :private, :boolean, :default => false
  end

  def self.down
    remove_column :base_items, :private
    add_column :items, :private, :boolean, :default => false
  end
end
