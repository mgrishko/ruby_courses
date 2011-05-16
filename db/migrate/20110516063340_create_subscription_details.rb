class CreateSubscriptionDetails < ActiveRecord::Migration
  def self.up
    create_table :subscription_details do |t|
      t.integer :subscription_id, :null => false
      t.integer :item_id, :null => false
      t.timestamps
    end
    add_index :subscription_details, [:subscription_id, :item_id], :unique => true
  end

  def self.down
    drop_table :subscription_details
  end
end
