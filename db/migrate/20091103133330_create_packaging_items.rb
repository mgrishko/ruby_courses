class CreatePackagingItems < ActiveRecord::Migration
  def self.up
    create_table :packaging_items do |t|
      t.integer :article_id
      t.integer :packaging_item_id

      t.integer :record_code
      t.string :name
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :packaging_items
  end
end
