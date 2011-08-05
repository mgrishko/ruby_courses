# == Schema Information
#
# Table name: subscription_details
#
#  id              :integer         not null, primary key
#  subscription_id :integer         not null
#  item_id         :integer         not null
#  created_at      :datetime
#  updated_at      :datetime
#

class SubscriptionDetails < ActiveRecord::Base
end



