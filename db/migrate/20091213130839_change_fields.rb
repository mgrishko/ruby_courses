class ChangeFields < ActiveRecord::Migration
  def self.up
    remove_column :base_items, :base_item_id
    change_column :base_items, :country_of_origin_id, :string, :limit => 2
    rename_column :base_items, :country_of_origin_id, :country_of_origin_code
    rename_column :gpcs, :gpc_id, :code
    rename_column :base_items, :gpc, :gpc_code
  end

  def self.down
    add_column :base_items, :base_item_id, :integer
    rename_column :base_items, :country_of_origin_code, :country_of_origin_id
    change_column :base_items, :country_of_origin_id, :integer
    rename_column :gpcs, :code, :gpc_id
    rename_column :base_items, :gpc_code, :gpc
  end
end
