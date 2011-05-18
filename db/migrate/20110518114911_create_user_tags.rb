class CreateUserTags < ActiveRecord::Migration
  def self.up
    create_table :user_tags do |t|
      t.integer :tag_id, :null => false
      t.integer :user_id, :null => false
      t.integer :author_id, :null => false

      t.timestamps
    end
    add_index :user_tags, [:tag_id, :user_id, :author_id], :unique => true
  end

  def self.down
    drop_table :user_tags
  end
end
