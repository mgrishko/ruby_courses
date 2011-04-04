class SubscriptionResult < ActiveRecord::Base
  include AASM

  validates_uniqueness_of :base_item_id, :scope => :subscription_id

  belongs_to :subscription
  belongs_to :base_item

  aasm_column :status
  aasm_initial_state :new
  
  aasm_state :new
  aasm_state :accepted
  aasm_state :canceled

  aasm_event :accept do
    transitions :to => :accepted, :from => :new
  end

  aasm_event :cancel do
    transitions :to => :canceled, :from => :new
  end

end
