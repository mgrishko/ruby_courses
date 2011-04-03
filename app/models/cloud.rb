class Cloud < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  belongs_to :user
end
