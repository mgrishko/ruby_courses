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

