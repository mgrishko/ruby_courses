require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_validate_presence_of :gtin
  context "Numbers less than 8 in length are accepted" do
    should_allow_values_for :gtin, 
      17, 24, 31, 48,
      109, 116, 123
    should_not_allow_values_for :gtin, 
      18, 25, 32,49,
      110, 117, 124
  end

  context "Numbers with length greater then 8 and less then 12 are not accepted" do
    #9
    should_not_allow_values_for :gtin, 100000001, 200000002, 300000003
    #10
    should_not_allow_values_for :gtin, 1000000003, 2000000006, 3000000009
    #11
    should_not_allow_values_for :gtin, 10000000003, 20000000002, 30000000003
  end

  context "Numbers with length greater then 14 are not accepted" do
    should_not_allow_values_for :gtin, 30000000000003, 200000000006, 300000000009
  end
end
