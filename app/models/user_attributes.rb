# == Schema Information
#
# Table name: user_attributes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  author_id  :integer(4)      not null
#  comment    :text
#  inner_id   :text
#  created_at :datetime
#  updated_at :datetime
#

class UserAttributes < ActiveRecord::Base
end

