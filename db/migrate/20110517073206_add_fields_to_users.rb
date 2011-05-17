class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :description, :text
    add_column :users, :contacts, :text
  end

  def self.down
    remove_column :users, :contacts
    remove_column :users, :description
  end
end
