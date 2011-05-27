class Comment < ActiveRecord::Base
  
  has_one :event, :as => :content

  belongs_to :user
  belongs_to :item
  belongs_to :base_item
  after_save :update_root_replies #trigger for root

  def get_children
    Comment.all(:conditions => {:root_id => self.id})
  end
  
  def get_root
    Comment.find(:first, :conditions => {:id => self.root_id})
  end

  def get_parent
    Comment.find(:first, :conditions => {:id => self.parent_id})
  end

  def update_root_replies
    if self.root_id
      root = Comment.find(self.root_id)
      root.replies = Comment.count(:conditions => {:root_id => self.root_id})
      root.save
    end
  end

  def get_url(current_user)
    if current_user.retailer?
      "/base_items/#{self.base_item_id}?view=true#c-#{self.id}"
    else
      "/base_items/#{self.base_item_id}#c-#{self.id}"
    end
  end

  def get_title
    self.content
  end

  def get_description
    self.base_item.item_description
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

