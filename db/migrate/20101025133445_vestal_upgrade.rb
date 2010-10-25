class VestalUpgrade < ActiveRecord::Migration
  def self.up
    change_table :versions do |t|
      t.belongs_to :user, :polymorphic => true
      t.string :user_name
      t.string :tag
    end

    change_table :versions do |t|
      t.index [:user_id, :user_type]
      t.index :user_name
      t.index :tag
    end
  end

  def self.down
  end
end
