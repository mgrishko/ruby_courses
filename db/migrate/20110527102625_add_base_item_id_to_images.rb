class AddBaseItemIdToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :base_item_id, :integer
  end

  def self.down
    remove_column :images, :base_item_id
  end
end
