require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: items
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)     default(""), not null
#

