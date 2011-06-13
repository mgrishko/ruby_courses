class SubscriptionResult < ActiveRecord::Base
  include AASM

  has_one :event, :as => :content, :dependent => :destroy

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

  scope :accepted, where(:status => 'accepted')

  def status_for_title
    return "Данные отправлены" if self.new?
    return "Данные акцептованы" if self.accepted?
    "Данные не приняты"
  end

  def get_url(current_user)
    if current_user.retailer?
      "/subscription_results/#{self.subscription_id}"
    else
      "/base_items/#{self.base_item_id}"
    end
  end

  def get_title
    self.base_item.item_description
  end

  def get_description
    "<div class='fleft sr-status sr-#{self.status}' title='#{self.status_for_title}'></div><div class='fleft'>&nbsp;#{self.base_item.item_description}</div>".html_safe

  end

end

