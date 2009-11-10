class RenameColumnsFromRecordCodeToGtin < ActiveRecord::Migration
  def self.up
    rename_column :packaging_items, :record_code, :gtin
    rename_column :articles, :record_code, :gtin
  end

  def self.down
    rename_column :packaging_items, :gtin, :record_code
    rename_column :articles, :gtin, :record_code
  end
end
