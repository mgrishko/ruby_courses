class Item < ActiveRecord::Base
  has_many :base_items
  belongs_to :user
  has_many :comments, :conditions => '#{Comment.table_name}.user_id = #{self.send(:user_id)}'
  has_many :tags, :through => :clouds
  has_many :clouds
end