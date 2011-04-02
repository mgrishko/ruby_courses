class CreateSubscriptionResults < ActiveRecord::Migration
  def self.up
    create_table :subscription_results do |t|
      t.integer :subscription_id, :null => false, :options =>
	"CONSTRAINT fk_subscription_result_subscriptions REFERENCES subscriptions(id)"
      t.integer :base_item_id, :null => false, :options => 
	"CONSTRAINT fk_subscription_result_base_items REFERENCES base_items(id)"
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :subscription_results
  end
end
