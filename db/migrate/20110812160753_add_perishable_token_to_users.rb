class AddPerishableTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :perishable_token, :string
    change_column_null :users, :gln, false
  end

  def self.down
    change_column_null :users, :gln, true
    remove_column :users, :perishable_token
  end
end
