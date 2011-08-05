# == Schema Information
#
# Table name: user_tags
#
#  id         :integer         not null, primary key
#  tag_id     :integer         not null
#  user_id    :integer         not null
#  author_id  :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

class UserTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  #belongs_to :author
  validates_presence_of :tag_id
end



