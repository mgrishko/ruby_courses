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

  context "Check numeric numbers " do
    should_validate_numericality_of :gtin, :manufacturer_gln, :content, :content_uom, 
      :gross_weight, :vat, :gpc, :country_of_origin, :minimum_durability_from_arrival, :packaging_type, :height, :depth, :width 
  end

  context "Checking decimal values" do
    should_allow_values_for :content, 0.001, 0.002, 0.01, 0.1, 1, 999999999
    should_not_allow_values_for :content, 1999999999, 1000000000, 0.0001, 0.00001
  end

  context "Check for valid lengths " do
    context "exact" do
      should_ensure_length_is :manufacturer_gln, 13
      should_ensure_length_is :gtin, 14
    end

    context "ranged" do 
      should_ensure_length_in_range :gross_weight, (1..7)
      should_ensure_length_in_range :plu_description, (1..12)
      should_ensure_length_in_range :depth, (1..5)
      should_ensure_length_in_range :item_name_long_en, (1..30)
      should_ensure_length_in_range :height, (1..5)
      should_ensure_length_in_range :manufacturer_name, (1..35)
      should_ensure_length_in_range :internal_item_id, (1..20)
      should_ensure_length_in_range :item_name_long_ru, (1..30)
      should_ensure_length_in_range :minimum_durability_from_arrival, (1..4)
      should_ensure_length_in_range :width, (1..5)
    end
  end
end
