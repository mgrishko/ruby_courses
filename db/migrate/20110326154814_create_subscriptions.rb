class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer  "retailer_id"
      t.integer  "supplier_id"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
