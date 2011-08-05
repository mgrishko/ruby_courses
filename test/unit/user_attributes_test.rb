require 'test_helper'

class UserAttributesTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: user_attributes
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  author_id  :integer         not null
#  comment    :text
#  inner_id   :text
#  created_at :datetime
#  updated_at :datetime
#

