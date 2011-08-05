# == Schema Information
#
# Table name: receivers
#
#  id           :integer         not null, primary key
#  base_item_id :integer         not null
#  user_id      :integer         not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Receiver < ActiveRecord::Base
  belongs_to :user
  belongs_to :base_item
end



