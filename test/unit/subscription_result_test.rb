require 'test_helper'

class SubscriptionResultTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: subscription_results
#
#  id              :integer         not null, primary key
#  subscription_id :integer         not null
#  base_item_id    :integer         not null
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

