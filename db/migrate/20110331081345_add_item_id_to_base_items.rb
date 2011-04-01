class AddItemIdToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :item_id, :integer, :null => false, :options =>
      "CONSTRAINT fk_base_item_items REFERENCES items(id)"
  end

  def self.down
    remove_column :base_items, :item_id
  end
end
