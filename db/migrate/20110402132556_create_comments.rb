class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id, :null => false, :options => 
	"CONSTRAINT fk_comment_users REFERENCES users(id)"
      t.integer :item_id, :null => false, :options =>
	"CONSTRAINT fk_comment_items REFERENCES items(id)"
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
