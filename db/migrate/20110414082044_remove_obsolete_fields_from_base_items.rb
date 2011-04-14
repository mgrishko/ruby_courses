class RemoveObsoleteFieldsFromBaseItems < ActiveRecord::Migration
  def self.up
    remove_column :base_items, :plu_description
    remove_column :base_items, :name
    remove_column :base_items, :item_name_long_ru
    remove_column :base_items, :item_name_long_en
  end

  def self.down
    add_column :base_items, :item_name_long_en, :string
    add_column :base_items, :item_name_long_ru, :string
    add_column :base_items, :name, :string
    add_column :base_items, :plu_description, :string
  end
end
