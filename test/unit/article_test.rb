require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "Gtin: " do
    should_validate_presence_of :gtin
    context "Numbers less than 8 in length are accepted" do
      should_allow_values_for :gtin, 
        17, 24, 31, 48,
        109, 116, 123
      should_not_allow_values_for :gtin, 
        18, 25, 32,49,
        110, 117, 124, :message => "checksum is not correct"
    end

    context "Numbers with length greater then 8 and less then 12 are not accepted" do
      #9
      should_not_allow_values_for :gtin, 100000001, 200000002, 300000003, :message => "has invalid length"
      #10
      should_not_allow_values_for :gtin, 1000000003, 2000000006, 3000000009, :message => "has invalid length"
      #11
      should_not_allow_values_for :gtin, 10000000003, 20000000002, 30000000003, :message => "has invalid length"
    end

    context "Numbers with length greater then 14 are not accepted" do
      should_not_allow_values_for :gtin, 300000000000007, 400000000000002, 900000000000009, :message => "has invalid length"
    end
  end

  context "Check numeric numbers " do
    should_validate_numericality_of :gtin, :manufacturer_gln, :content, :content_uom, 
      :gross_weight, :vat, :gpc, :country_of_origin, :minimum_durability_from_arrival, :packaging_type, :height, :depth, :width 
  end

  context "Checking decimal values" do
    should_allow_values_for :content, 0.001, 0.002, 0.01, 0.1, 1, 999999999
    should_not_allow_values_for :content, 1999999999, 1000000000, 0.0001, 0.00001, :message => /must be .* than/
  end

  context "Check for valid lengths " do
    context "exact" do
      should_ensure_value_in_range :manufacturer_gln, (10 ** (13 - 1))..(10 ** 13 - 1), :low_message => /must be greater than/, :high_message => /must be less than/
      should_ensure_value_in_range :gtin, (10 ** (14 - 1))..(10 ** 14 - 1), :low_message => /must be greater than/, :high_message => /must be less than/
    end

  end
end
