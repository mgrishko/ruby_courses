class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :user_id, :null => false, :options =>
        "CONSTRAINT fk_item_users REFERENCES users(id)"

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
