module SubscriptionHelper
  
  def get_value_by_item_id item
    subscription = Subscription.find(:first, :conditions => {:retailer_id => current_user.id, :supplier_id => item.user.id, :status => 'active'})
    if subscription
      return t('subscription.unsubscribe') if subscription.find_in_details(item.id)
    end
    t('subscription.subscribe')
  end

end
