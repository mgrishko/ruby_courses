class Comment < ActiveRecord::Base

  has_one :event, :as => :content

  belongs_to :user
  belongs_to :item
  belongs_to :base_item
  after_save :update_root_replies #trigger for root

  scope :roots, where("root_id IS NULL")

  def get_children
    Comment.where(:root_id => self.id)
  end

  def get_root
    Comment.where(:id => self.root_id).first
  end

  def get_parent
    Comment.where(:id => self.parent_id).first
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
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  item_id      :integer         not null
#  content      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  base_item_id :integer         default(0), not null
#  parent_id    :integer
#  root_id      :integer
#  replies      :integer         default(0), not null
#

