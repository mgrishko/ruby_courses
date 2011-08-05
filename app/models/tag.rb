# == Schema Information
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#  kind       :integer         default(1), not null
#

class Tag < ActiveRecord::Base
  has_many :items, :through => :clouds
  has_many :clouds
  validate :name, :presence => true, :length => { :within => 1..15 }
end



