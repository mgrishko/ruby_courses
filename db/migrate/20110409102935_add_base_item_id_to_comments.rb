class AddBaseItemIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :base_item_id, :integer, :null => false, :default => 0
    Comment.reset_column_information
    Comment.all.each do |comment|
      comment.update_attribute 'base_item_id', BaseItem.first(:conditions => {:item_id => comment.item_id}, :order => "id DESC")
    end
  end

  def self.down
    remove_column :comments, :base_item_id
  end
end