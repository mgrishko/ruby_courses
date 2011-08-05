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

# == Schema Information
#
# Table name: packaging_items
#
#  id                                       :integer         not null, primary key
#  base_item_id                             :integer
#  parent_id                                :integer
#  gtin                                     :string(255)
#  item_name_long_ru                        :string(255)
#  created_at                               :datetime
#  updated_at                               :datetime
#  user_id                                  :integer
#  number_of_next_lower_item                :integer
#  number_of_bi_items                       :integer
#  despatch_unit                            :boolean         default(FALSE)
#  invoice_unit                             :boolean         default(FALSE)
#  order_unit                               :boolean         default(FALSE)
#  consumer_unit                            :boolean         default(FALSE)
#  gross_weight                             :integer
#  packaging_type                           :string(255)
#  height                                   :integer
#  depth                                    :integer
#  width                                    :integer
#  published                                :boolean         default(FALSE)
#  rgt                                      :integer
#  lft                                      :integer
#  level_cache                              :integer         default(0)
#  quantity_of_layers_per_pallet            :integer         default(1)
#  quantity_of_trade_items_per_pallet_layer :integer         default(1)
#  stacking_factor                          :integer         default(1)
#

