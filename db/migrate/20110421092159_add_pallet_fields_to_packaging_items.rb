class AddPalletFieldsToPackagingItems < ActiveRecord::Migration
  def self.up
    #quantityOfLayersPerPallet
    #quantityOfTradeItemsPerPalletLayer
    #stackingFactor
    add_column :packaging_items, :quantity_of_layers_per_pallet, :integer, :default => 1
    add_column :packaging_items, :quantity_of_trade_items_per_pallet_layer, :integer, :default => 1
    add_column :packaging_items, :stacking_factor, :integer, :default => 1
  end

  def self.down
    remove_column :packaging_items, :quantity_of_layers_per_pallet
    remove_column :packaging_items, :quantity_of_trade_items_per_pallet_layer
    remove_column :packaging_items, :stacking_factor
  end
end
