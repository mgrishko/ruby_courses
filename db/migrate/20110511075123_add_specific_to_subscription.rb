class AddSpecificToSubscription < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :specific, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :subscriptions, :specific
  end
end
