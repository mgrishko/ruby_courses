class RemoveColumnsFromTags < ActiveRecord::Migration
  def self.up
    remove_column :tags, :user_id
    remove_column :tags, :item_id
  end

  def self.down
    add_column :tags, :user_id, :integer
    add_column :tags, :item_id, :integer
  end
end
