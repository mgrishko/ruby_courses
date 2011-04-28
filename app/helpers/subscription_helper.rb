module SubscriptionHelper
  
  def get_value_by_item_id item
    subscription = Subscription.find(:first, :conditions => {:retailer_id => current_user.id, :supplier_id => item.user.id, :status => 'active'})
    if subscription
      return 'Отписаться' if Subscription.present_and_find_in_details(subscription.details, item.id)
    end
    'Подписаться'
  end

end
