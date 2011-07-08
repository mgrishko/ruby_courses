# == Schema Information
#
# Table name: receivers
#
#  id           :integer(4)      not null, primary key
#  base_item_id :integer(4)      not null
#  user_id      :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Receiver < ActiveRecord::Base
  belongs_to :user
  belongs_to :base_item
end

