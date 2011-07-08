# == Schema Information
#
# Table name: gpcs
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  code                :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  segment_description :string(255)
#  description         :string(255)
#  group               :string(255)
#

class Gpc < ActiveRecord::Base

end

