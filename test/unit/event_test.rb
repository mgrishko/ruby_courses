require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  content_type :string(32)      not null
#  content_id   :integer         not null
#  created_at   :datetime
#  updated_at   :datetime
#

