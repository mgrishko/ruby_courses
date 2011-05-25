class RenameItemIdToBaseItemIdInReceivers < ActiveRecord::Migration
  def self.up
    rename_column :receivers, :item_id, :base_item_id
  end

  def self.down
    rename_column :receivers, :base_item_id, :item_id
  end
end
