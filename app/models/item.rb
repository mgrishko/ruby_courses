class Item < ActiveRecord::Base
  has_many :base_items
  belongs_to :user
end
