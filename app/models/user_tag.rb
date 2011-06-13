class UserTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  #belongs_to :author
  validates_presence_of :tag_id
end

