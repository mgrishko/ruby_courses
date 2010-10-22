require 'migration_helpers'

class AddUserIdToInfoTables < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    add_column :articles, :user_id, :integer
    add_column :packaging_items, :user_id, :integer
    user = get_user

    [::Article, ::PackagingItem].each do |table|
      table.update_all ['user_id = ?', user.to_param]
    end

  end

  def self.down
    remove_column :articles, :user_id
    remove_column :packaging_items, :user_id
  end
end
