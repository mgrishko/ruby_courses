class AddGroupToGpcs < ActiveRecord::Migration
  def self.up
    add_column :gpcs, :group, :string
  end

  def self.down
    remove_column :gpcs, :group
  end
end
