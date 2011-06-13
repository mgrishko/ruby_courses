class Receiver < ActiveRecord::Base
  belongs_to :user
  belongs_to :base_item
end

