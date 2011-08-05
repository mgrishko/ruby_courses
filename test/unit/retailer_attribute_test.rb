require 'test_helper'

class RetailerAttributeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: retailer_attributes
#
#  id                        :integer         not null, primary key
#  user_id                   :integer         not null
#  item_id                   :integer         not null
#  retailer_article_id       :integer
#  retailer_classification   :string(255)
#  retailer_item_description :string(178)
#  retailer_comment          :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  base_item_id              :integer
#

