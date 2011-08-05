# == Schema Information
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  code       :string(2)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  translates :description
end



