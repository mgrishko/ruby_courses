class AddUserInfoToUsers < ActiveRecord::Migration
  def self.up
#    add_column :users, :contacts, :text
    add_column :users, :company_name, :string
    add_column :users, :locale, :string
    add_column :users, :website, :string
  end

  def self.down
    remove_column :users, :website
    remove_column :users, :locale
    remove_column :users, :company_name
#    remove_column :users, :contacts
  end
end
