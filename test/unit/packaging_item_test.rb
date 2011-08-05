require 'test_helper'

class PackagingItemTest < ActiveSupport::TestCase

  def test_correct_table_name
    assert_equal packaging_items(:one).class.table_name, "packaging_items"
  end

  def test_name_is_alias_for_item_name_long_ru
    f = packaging_items(:one)
    assert_equal f.name, f.item_name_long_ru

    test_value = "test value"
    f.name = test_value
    assert_equal f.name, f.item_name_long_ru
    assert_equal f.item_name_long_ru, test_value

    f = PackagingItem.new(:name => test_value)
    assert_equal f.name, test_value
    assert_equal f.item_name_long_ru, test_value
  end

  should_validate_uniqueness_of :gtin, :scoped_to => :user_id
  should_validate_numericality_of :number_of_next_lower_item, :number_of_bi_items, :gross_weight, :packaging_type, :height, :depth, :width
  should_ensure_value_in_range :gtin, (10 ** (14 - 1))..(10 ** 14 - 1), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :gross_weight, (1..9999999), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :number_of_next_lower_item, (1..999999), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :number_of_bi_items, (1..999999), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :depth, (1..99999), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :height, (1..99999), :low_message => /must be greater than/, :high_message => /must be less than/
  should_ensure_value_in_range :width, (1..99999), :low_message => /must be greater than/, :high_message => /must be less than/


end

