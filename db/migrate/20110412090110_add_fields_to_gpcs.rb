class AddFieldsToGpcs < ActiveRecord::Migration
  def self.up
    add_column :gpcs, :segment_description, :string
    add_column :gpcs, :description, :string
  end

  def self.down
    remove_column :gpcs, :description
    remove_column :gpcs, :segment_description
  end
end
