class ChangeItemsStatus < ActiveRecord::Migration
  def self.up
    execute "UPDATE items SET status='add' WHERE status='new'"
    execute "UPDATE items SET status='change' WHERE status='changed'"
    change_table :items do |t|
      t.change :status, :string, :null => false, :default => ''
    end
  end

  def self.down
    execute "UPDATE items SET status='new' WHERE status='add'"
    execute "UPDATE items SET status='changed' WHERE status='change'"
    change_table :items do |t|
      t.change :status, :string, :null => false, :default => "new"
    end
  end
end
