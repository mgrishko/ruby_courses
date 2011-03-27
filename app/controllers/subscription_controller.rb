class SubscriptionController < ApplicationController
  before_filter :require_user
  
  def index
    @base_items = BaseItem.paginate :page => params[:page], :per_page => 10, :joins => "left join users on users.id = base_items.user_id left join subscriptions on users.id = subscriptions.supplier_id",
    :conditions => ["subscriptions.retailer_id = ?", current_user.id], :order => "subscriptions.supplier_id"
  end

  def status
    if request.post? and params[:id]
      @subscription = Subscription.find(:first, :conditions => {:supplier_id => params[:id], :retailer_id => current_user.id});
      json = {'error' => 'Ошибка'}
      if @subscription
	@subscription.destroy
	json = {'text' => 'Подписаться'}
      else
	@subscription = Subscription.new(:supplier_id => params[:id], :retailer_id => current_user.id);
	if @subscription.save
	  json = {'text' => 'Отписаться'}
	end
      end
      render :json => json
    end
  end
end
