class AddPrivateToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :private, :boolean, :default => false
  end

  def self.down
    remove_column :items, :private
  end
end
