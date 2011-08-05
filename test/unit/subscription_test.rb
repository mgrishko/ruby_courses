require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer         not null, primary key
#  retailer_id :integer
#  supplier_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)
#  details     :string(255)
#  specific    :boolean         default(FALSE), not null
#

