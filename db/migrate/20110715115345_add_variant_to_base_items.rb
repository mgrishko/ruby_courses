class AddVariantToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :variant, :string
  end

  def self.down
    remove_column :base_items, :variant
  end
end

