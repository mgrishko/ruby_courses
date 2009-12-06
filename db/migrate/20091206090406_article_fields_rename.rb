class ArticleFieldsRename < ActiveRecord::Migration
  def self.up
    rename_column :articles, :country_of_origin, :country_of_origin_id
  end

  def self.down
    rename_column :articles, :country_of_origin_id, :country_of_origin
  end
end
