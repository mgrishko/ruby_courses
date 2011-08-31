class AddActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active, :boolean
    User.reset_column_information
    User.all.each do |user|
      user.active = true
      user.save :validate => false
    end
  end

  def self.down
    remove_column :users, :active
  end
end
