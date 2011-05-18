class AddKindToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :kind, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :tags, :kind
  end
end
