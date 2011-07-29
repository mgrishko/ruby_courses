# == Schema Information
#
# Table name: tags
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#  kind       :integer(4)      default(1), not null
#

class Tag < ActiveRecord::Base
  has_many :items, :through => :clouds
  has_many :clouds
  validate :name, :presence => true, :length => { :within => 1..50 }
end

