class AddStateToBaseItems < ActiveRecord::Migration
  def self.up
    add_column :base_items, :state, :string, :default => 'add'
  end

  def self.down
    remove_column :base_items, :state
  end
end
