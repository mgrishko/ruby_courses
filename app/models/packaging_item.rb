require 'gtin_field_validations'

class PackagingItem < ActiveRecord::Base
  include FilterByUser
  set_table_name :packaging_items
  acts_as_tree :foreign_key => :packaging_item_id
  belongs_to :base_items, :conditions => {:packaging_item_id => nil}
  belongs_to :user

  validates_is_gtin :gtin
  validates_presence_of :gtin
  validates_numericality_of :gtin, :less_than => 10 ** 14, :greater_than_or_equal_to => (10 ** (14 - 1))
  validates_uniqueness_of :gtin, :scope => :user_id


  validates_numericality_of :number_of_next_lower_item, :less_than_or_equal_to => 999999, :greater_than => 0
  validates_numericality_of :number_of_bi_items, :less_than_or_equal_to => 999999, :greater_than => 0
  validates_numericality_of :gross_weight, :less_than => 10 ** 7, :greater_than => 0
  validates_numericality_of :height, :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :depth, :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :width, :less_than => 10 ** 5, :greater_than => 0


  def name
    item_name_long_ru
  end

  def name=(value)
    write_attribute :item_name_long_ru, value
  end
end
