class CreatePiPublishedField < ActiveRecord::Migration
  def self.up
    remove_column :packaging_items, :status
    add_column :packaging_items, :published, :boolean, :default => false
    change_column :packaging_items, :packaging_type, :string
    change_column :packaging_items, :despatch_unit, :boolean, :default => false
    change_column :packaging_items, :consumer_unit, :boolean, :default => false
    change_column :packaging_items, :invoice_unit, :boolean, :default => false
    change_column :packaging_items, :order_unit, :boolean, :default => false
    change_column :articles, :despatch_unit, :boolean, :default => false
    change_column :articles, :consumer_unit, :boolean, :default => false
    change_column :articles, :invoice_unit, :boolean, :default => false
    change_column :articles, :order_unit, :boolean, :default => false
  end

  def self.down
    remove_column :packaging_items, :published
    add_column :packaging_items, :status, :integer
    change_column :packaging_items, :packaging_type, :integer
  end
end
