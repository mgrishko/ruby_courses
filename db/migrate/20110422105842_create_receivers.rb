class CreateReceivers < ActiveRecord::Migration
  def self.up
    create_table :receivers do |t|
      t.integer :item_id, :null => false, :options =>
        "CONSTRAINT fk_receiver_items REFERENCES items(id)"
      t.integer :user_id, :null => false, :options =>
	"CONSTRAINT fk_receiver_items REFERENCES user(id)"

      t.timestamps
    end
  end

  def self.down
    drop_table :receivers
  end
end
