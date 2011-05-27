class Subscription < ActiveRecord::Base
  include AASM
  
  has_one :event, :as => :content

  belongs_to :retailer, :class_name => 'User', :foreign_key => 'retailer_id'
  belongs_to :supplier, :class_name => 'User', :foreign_key => 'supplier_id'
  has_many :subscription_results
  has_many :subscription_details

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
    Subscription.count_by_sql <<-SQL
      SELECT COUNT(*) FROM subscription_results 
        JOIN base_items ON subscription_results.base_item_id = base_items.id
        JOIN items ON base_items.item_id = items.id
      WHERE subscription_id=#{id} AND (SELECT count(*) FROM base_items WHERE item_id=items.id AND status='published') = 1
        AND subscription_results.status = 'new'
    SQL
  end
  def changed_items_count
    Subscription.count_by_sql <<-SQL
      SELECT COUNT(*) FROM subscription_results 
        JOIN base_items ON subscription_results.base_item_id = base_items.id
        JOIN items ON base_items.item_id = items.id
      WHERE subscription_id=#{id} AND (SELECT count(*) FROM base_items WHERE item_id=items.id AND status='published') > 1
        AND subscription_results.status = 'new'
    SQL
  end

  def find_in_details id
    SubscriptionDetails.find(:first, :conditions => {:subscription_id => self.id, :item_id => id})
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
#

