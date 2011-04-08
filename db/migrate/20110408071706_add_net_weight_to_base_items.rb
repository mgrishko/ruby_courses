class AddNetWeightToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :net_weight, :integer
  end

  def self.down
    remove_column :base_items, :net_weight
  end
end
