class PackagingItem < ActiveRecord::Base
  set_table_name :packaging_items
  acts_as_tree :foreign_key => :packaging_item_id
  belongs_to :articles
end
