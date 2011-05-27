class AddBaseItemIdToRetailerAttributes < ActiveRecord::Migration
  def self.up
    add_column :retailer_attributes, :base_item_id, :integer
  end

  def self.down
    remove_column :retailer_attributes, :base_item_id
  end
end
