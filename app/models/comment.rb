class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :base_item
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

