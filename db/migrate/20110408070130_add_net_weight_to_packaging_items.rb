class AddNetWeightToPackagingItems < ActiveRecord::Migration
  def self.up
    add_column :packaging_items, :net_weight, :integer
  end

  def self.down
    remove_column :packaging_items, :net_weight
  end
end
