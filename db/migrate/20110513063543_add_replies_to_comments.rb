class AddRepliesToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :replies, :integer, :null => false, :default => 0
    
    execute "create temporary table t (select * from comments)"
    execute "update comments c set replies=(select count(*) from t where root_id=c.id)"

  end

  def self.down
    remove_column :comments, :replies
  end
end
