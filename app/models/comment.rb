class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :base_item
end
