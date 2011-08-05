require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: countries
#
#  id          :integer         not null, primary key
#  code        :string(2)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

