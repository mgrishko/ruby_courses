class Tag < ActiveRecord::Base
  has_many :items, :through => :clouds
  has_many :clouds
  
  validates_presence_of :name
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

