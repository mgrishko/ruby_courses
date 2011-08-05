require 'test_helper'

class CloudTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: clouds
#
#  id         :integer         not null, primary key
#  tag_id     :integer         not null
#  item_id    :integer         not null
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

