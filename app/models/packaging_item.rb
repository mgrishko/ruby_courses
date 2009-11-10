class PackagingItem < ActiveRecord::Base
  include GtinFieldValidations
  validates_gtin
  set_table_name :packaging_items
  acts_as_tree :foreign_key => :packaging_item_id
  belongs_to :articles, :conditions => {:packaging_item_id => nil}

  def name
    item_name_long_ru
  end

  def name=(value)
    write_attribute :item_name_long_ru, value
  end
end
