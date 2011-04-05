class Cloud < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  belongs_to :user
  validates_presence_of :tag_id
end
