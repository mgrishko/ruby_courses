class DropVestalVersionsTable < ActiveRecord::Migration
  def self.up
    drop_table :versions
  end

  def self.down
    create_table :versions do |t|
      t.belongs_to :versioned, :polymorphic => true
      t.text :changes
      t.integer :number
      t.datetime :created_at
    end

    change_table :versions do |t|
      t.index [:versioned_type, :versioned_id]
      t.index :number
      t.index :created_at
    end

  end
end
