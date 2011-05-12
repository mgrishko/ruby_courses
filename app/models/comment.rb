class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :base_item

  def get_children
    Comment.all(:conditions => {:root_id => self.id})
  end
  
  def get_root
    Comment.find(:first, :conditions => {:id => self.root_id})
  end

  def get_parent
    Comment.find(:first, :conditions => {:id => self.parent_id})
  end
end

# == Schema Information
#
# Table name: comments
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)      not null
#  item_id      :integer(4)      not null
#  content      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  base_item_id :integer(4)      not null
#

