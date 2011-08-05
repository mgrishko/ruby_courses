require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: comments
#
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  item_id      :integer         not null
#  content      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  base_item_id :integer         default(0), not null
#  parent_id    :integer
#  root_id      :integer
#  replies      :integer         default(0), not null
#

