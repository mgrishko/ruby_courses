class Subscription < ActiveRecord::Base
  include AASM

  belongs_to :retailer, :class_name => 'User', :foreign_key => 'retailer_id'
  belongs_to :supplier, :class_name => 'User', :foreign_key => 'supplier_id'
  has_many :subscription_results

  aasm_column :status
  aasm_initial_state :active

  aasm_state :active
  aasm_state :canceled

  aasm_event :cancel do
    transitions :to => :canceled, :from => :active
  end
  aasm_event :active do
    transitions :to => :active, :from => :canceled
  end
end
