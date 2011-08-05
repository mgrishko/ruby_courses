require 'test_helper'

class GpcTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

# == Schema Information
#
# Table name: gpcs
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  code                :integer
#  created_at          :datetime
#  updated_at          :datetime
#  segment_description :string(255)
#  description         :string(255)
#  group               :string(255)
#

