# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer(4)      not null, primary key
#  retailer_id :integer(4)
#  supplier_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)
#  details     :string(255)
#  specific    :boolean(1)      default(FALSE), not null
#

class Subscription < ActiveRecord::Base
  include AASM

  has_one :event, :as => :content

  belongs_to :retailer, :class_name => 'User', :foreign_key => 'retailer_id'
  belongs_to :supplier, :class_name => 'User', :foreign_key => 'supplier_id'
  has_many :subscription_results
  has_many :subscription_details, :class_name => "SubscriptionDetails"

  aasm_column :status
  aasm_initial_state :active

  aasm_state :active
  aasm_state :canceled, :enter => :reset_subscription

  aasm_event :cancel do
    transitions :to => :canceled, :from => :active
  end
  aasm_event :active do
    transitions :to => :active, :from => :canceled
  end

  scope :active, where(:status => 'active')
  scope :usual, where(:specific => false)
  scope :specific, where(:specific => true)
  def get_url(current_user)
    if current_user.retailer?
      "/suppliers/"
    else
      "/profiles/#{self.retailer_id}"
    end
  end

  def get_title
  end

  def get_description
    self.supplier.name
  end


  def reset_subscription
    self.details = '';
    self.specific = false;
    self.save
    SubscriptionDetails.delete_all(:subscription_id => self.id)
  end

  def new_items_count
    published = BaseItem.published.select("base_items.id, count(*) as count").group("item_id")
    published_ids = published.map{|bi| bi.id if bi.count == 1}.compact
    subscription_results.where(:base_item_id => published_ids,:status => 'new').count()
  end

  #FIXME: needs refactoring
  def changed_items_count
    published = BaseItem.published.select("base_items.id, count(*) as count").group("item_id")
    published_ids = published.map{|bi| bi.id if bi.count > 1}.compact
    subscription_results.where(:base_item_id => published_ids,:status => 'new').count()
  end

  def find_in_details id
    self.subscription_details.where(:item_id => id).first
    #if details.to_s != ''
    #  return details.split(',').include? id.to_s
    #else
    #  return false
    #end
  end

  #def self.present_and_find_in_details details, id # will be drop soon
  #  if details.to_s != ''
  #    return details.split(',').include? id.to_s
  #  else
  #    return false
  #  end
  #end
end

