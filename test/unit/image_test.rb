require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: images
#
#  id           :integer         not null, primary key
#  item_id      :integer         not null
#  created_at   :datetime
#  updated_at   :datetime
#  base_item_id :integer
#

