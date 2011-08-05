require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  gln               :integer
#  pw_hash           :string(255)
#  persistence_token :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  name              :string(255)
#  description       :text
#  contacts          :text
#  roles_mask        :integer
#  email             :string(255)
#

