class ArticleFieldsRename < ActiveRecord::Migration
  def self.up
    rename_column :articles, :country_of_origin, :country_of_origin_id
    change_column :articles, :status, :string, :default => nil
  end

  def self.down
    rename_column :articles, :country_of_origin_id, :country_of_origin
    change_column :articles, :status, :integer
  end
end
