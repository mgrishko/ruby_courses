# == Schema Information
#
# Table name: countries
#
#  id          :integer(4)      not null, primary key
#  code        :string(2)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Country < ActiveRecord::Base
end

