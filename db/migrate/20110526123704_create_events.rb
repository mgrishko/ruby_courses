class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id, :null => false
      t.string :content_type, :limit => 32, :null => false
      t.integer :content_id, :null => false

      t.timestamps
    end
    add_index :events, :content_type
    add_index :events, :user_id

  end

  def self.down
    drop_table :events
  end
end
