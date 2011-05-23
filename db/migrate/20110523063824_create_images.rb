class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :item_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
