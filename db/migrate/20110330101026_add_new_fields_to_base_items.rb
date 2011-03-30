class AddNewFieldsToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :brand, :string, :limit => 70, :null => false, :default => ''
    add_column :base_items, :subbrand, :string, :limit => 70
    add_column :base_items, :functional, :string, :limit => 35, :null => false, :default => ''
    add_column :base_items, :item_description, :string, :limit => 178
  end

  def self.down
    remove_column :base_items, :brand
    remove_column :base_items, :subbrand
    remove_column :base_items, :functional
    remove_column :base_items, :item_description
  end
end
