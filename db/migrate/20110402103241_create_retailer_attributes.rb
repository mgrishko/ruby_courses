class CreateRetailerAttributes < ActiveRecord::Migration
  def self.up
    create_table :retailer_attributes do |t|
      t.integer :user_id, :null => false, :options =>
	"CONSTRAINT fk_retailer_attribute_users REFERENCES users(id)"
      t.integer :item_id, :null => false, :options =>
	"CONSTRAINT fk_retailer_attribute_items REFERENCES items(id)"

      t.integer :retailer_article_id
      t.string :retailer_classification
      t.string :retailer_item_description, :limit => 178
      t.string :retailer_comment

      t.timestamps
    end
  end

  def self.down
    drop_table :retailer_attributes
  end
end
