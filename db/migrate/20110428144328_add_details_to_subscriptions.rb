class AddDetailsToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :details, :string
  end

  def self.down
    remove_column :subscriptions, :details
  end
end
