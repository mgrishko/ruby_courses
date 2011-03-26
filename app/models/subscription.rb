class Subscription < ActiveRecord::Base
  belongs_to :retailer, :class_name => 'User', :foreign_key => 'retailer_id'
  belongs_to :supplier, :class_name => 'User', :foreign_key => 'supplier_id'
end
