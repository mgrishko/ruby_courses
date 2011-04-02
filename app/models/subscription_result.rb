class SubscriptionResult < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :base_item
end
