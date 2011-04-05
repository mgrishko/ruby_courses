class Tag < ActiveRecord::Base
  has_many :items, :through => :clouds
  has_many :clouds
  
  validates_presence_of :name
end
