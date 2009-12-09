class RenameArticles < ActiveRecord::Migration
  def self.up
    rename_table :articles, :base_items
    rename_column :base_items, :article_id, :base_item_id
    rename_column :packaging_items, :article_id, :base_item_id
  end

  def self.down
    rename_table :base_items, :articles
    rename_column :articles, :base_item_id, :article_id
    rename_column :packaging_items, :base_item_id, :article_id
  end
end
