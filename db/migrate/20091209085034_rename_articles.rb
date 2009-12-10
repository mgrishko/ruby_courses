class RenameArticles < ActiveRecord::Migration
  def self.up
    rename_table :articles, :base_items
    rename_column :base_items, :article_id, :base_item_id
    rename_column :packaging_items, :article_id, :base_item_id
    rename_column :packaging_items, :packaging_item_id, :parent_id
    add_column :packaging_items, :rgt, :integer
    add_column :packaging_items, :lft, :integer
  end

  def self.down
    rename_table :base_items, :articles
    rename_column :articles, :base_item_id, :article_id
    rename_column :packaging_items, :base_item_id, :article_id
    rename_column :packaging_items, :parent_id, :packaging_item_id
    remove_column :packaging_items, :rgt
    remove_column :packaging_items, :lft
  end
end
