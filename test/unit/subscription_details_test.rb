require 'test_helper'

class SubscriptionDetailsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

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

