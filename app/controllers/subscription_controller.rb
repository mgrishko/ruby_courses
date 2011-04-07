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
	      if @subscription.active?
	        @subscription.cancel!
	        json = {'text' => 'Подписаться', 'flag' => false}
	      else
	        @subscription.active!
	        json = {'text' => 'Отписаться', 'flag' => true}
	      end
      else
	      @subscription = Subscription.new(:supplier_id => params[:id], :retailer_id => current_user.id);
	      if @subscription.save
	        json = {'text' => 'Отписаться', 'flag' => true}
	      end
      end
      render :json => json
    end
  end
  
  def instantstatus
    json = {'error' => 'Ошибка'}
    if request.post? and params[:id]
      @subscription = Subscription.find(:first, :conditions => {:supplier_id => params[:id], :retailer_id => current_user.id});
      if @subscription
	      if @subscription.active?
	        json = {'error' => 'У Вас уже есть подписка'}
	        return render :json => json
	      else
	        @subscription.active!
	      end
      else
	      @subscription = Subscription.new(:supplier_id => params[:id], :retailer_id => current_user.id);
	      @subscription.save
      end
      @supplier = User.find(params[:id])
      @supplier.all_fresh_base_items.each do |bi|
	      @subscription.subscription_results << SubscriptionResult.new(:base_item_id => bi.id, :subscription_id => @subscription_id)
      end
      json = {'text' => 'Недоступно', 'flag' => true}
    end
    render :json => json
  end
end
