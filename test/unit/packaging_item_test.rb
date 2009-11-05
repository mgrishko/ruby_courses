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
end
