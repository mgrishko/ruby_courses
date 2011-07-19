class AddRolesMaskToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :roles_mask, :integer
    User.reset_column_information
    User.all.each do |user|
      roles = []
      roles << 'admin' if user.is_admin?
      roles << 'retailer' if user.role == 'retailer'
      roles << 'global_supplier' if user.role == 'supplier'
      user.roles = roles
      user.save :validate => false
    end
    remove_column :users, :is_admin
    remove_column :users, :role
  end

  def self.down
    add_column :users, :is_admin, :boolean
    add_column :users, :role, :string
    User.reset_column_information
    User.all.each do |user|
      user.is_admin = true if user.is? :admin
      user.role = 'retailer' if user.is? :retailer
      user.role = 'supplier' if user.is? :global_supplier
      user.save :validate => false
    end
    remove_column :users, :roles_mask
  end
end
