class UserAttributes < ActiveRecord::Base
end


# == Schema Information
#
# Table name: user_attributes
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  author_id  :integer         not null
#  comment    :text
#  inner_id   :text
#  created_at :datetime
#  updated_at :datetime
#

