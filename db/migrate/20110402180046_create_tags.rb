class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :user_id, :null => false, :options =>
	"CONSTRAINT fk_tag_users REFERENCES users(id)"
      t.integer :item_id, :null => false, :options =>
        "CONSTRAINT fk_tag_items REFERENCES items(id)"
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
