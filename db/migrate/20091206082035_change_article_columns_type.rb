class ChangeArticleColumnsType < ActiveRecord::Migration
  def self.up
    change_column :articles, :content_uom, :string, :limit => 3
    change_column :articles, :packaging_type, :string, :limit => 3
  end

  def self.down
    change_column :articles, :content_uom, :integer
    change_column :articles, :packaging_type, :integer
  end
end
