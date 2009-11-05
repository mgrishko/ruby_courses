class ModifyNameColumnInPackagingItems < ActiveRecord::Migration
  def self.up
    rename_column :packaging_items, :name, :item_name_long_ru
  end

  def self.down
    rename_column :packaging_items, :item_name_long_ru, :name
  end
end
