# == Schema Information
#
# Table name: subscription_details
#
#  id              :integer(4)      not null, primary key
#  subscription_id :integer(4)      not null
#  item_id         :integer(4)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class SubscriptionDetails < ActiveRecord::Base
end

