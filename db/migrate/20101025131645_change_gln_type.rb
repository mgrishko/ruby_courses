class ChangeGlnType < ActiveRecord::Migration
  def self.up
    change_column :base_items, :gtin, :string
    change_column :packaging_items, :gtin, :string
  end

  def self.down
    change_column :base_items, :gtin, :integer
    change_column :packaging_items, :gtin, :integer
  end
end
