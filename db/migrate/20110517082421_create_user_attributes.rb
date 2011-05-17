class CreateUserAttributes < ActiveRecord::Migration
  def self.up
    create_table :user_attributes do |t|
      t.integer :user_id, :null => false
      t.integer :author_id, :null => false
      t.text :comment
      t.text :inner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_attributes
  end
end
