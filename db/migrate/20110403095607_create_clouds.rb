class CreateClouds < ActiveRecord::Migration
  def self.up
    create_table :clouds do |t|
      t.integer :tag_id, :null => false, :options =>
	"CONSTRAINT fk_cloud_tags REFERENCES tags(id)"

      t.integer :item_id, :null => false, :options =>
        "CONSTRAINT fk_cloud_items REFERENCES items(id)"

      t.integer :user_id, :null => false, :options =>
        "CONSTRAINT fk_cloud_users REFERENCES users(id)"

      t.timestamps
    end
    add_index :clouds, [:tag_id, :item_id, :user_id], :unique => true
  end

  def self.down
    drop_table :clouds
  end
end
