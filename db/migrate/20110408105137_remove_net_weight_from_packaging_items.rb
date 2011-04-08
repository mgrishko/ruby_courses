class RemoveNetWeightFromPackagingItems < ActiveRecord::Migration
  def self.up
    remove_column :packaging_items, :net_weight
  end

  def self.down
    add_column :packaging_items, :net_weight, :integer
  end
end
