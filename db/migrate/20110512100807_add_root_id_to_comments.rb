class AddRootIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :root_id, :integer
  end

  def self.down
    remove_column :comments, :root_id
  end
end
