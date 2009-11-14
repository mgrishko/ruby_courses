require 'gtin_field_validations'

class PackagingItem < ActiveRecord::Base
  include FilterByUser
  set_table_name :packaging_items
  acts_as_tree :foreign_key => :packaging_item_id
  belongs_to :articles, :conditions => {:packaging_item_id => nil}
  belongs_to :user
  validates_is_gtin :gtin
  validates_presence_of :gtin
  validates_numericality_of :gtin

  def name
    item_name_long_ru
  end

  def name=(value)
    write_attribute :item_name_long_ru, value
  end
end
