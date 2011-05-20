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
  
  def status_for_title
    return "Данные отправлены" if self.new?
    return "Данные акцептованы" if self.accepted?
    "Данные не приняты"
  end
end

# == Schema Information
#
# Table name: subscription_results
#
#  id              :integer(4)      not null, primary key
#  subscription_id :integer(4)      not null
#  base_item_id    :integer(4)      not null
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

