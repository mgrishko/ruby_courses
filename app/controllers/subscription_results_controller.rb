class SubscriptionResultsController < ApplicationController
  before_filter :require_user

  def index
    @results = current_user.subscription_results.sort_by(&:updated_at).reverse.group_by{|sr|sr.subscription}
  end
    
  def show
    @subscription = Subscription.first(:conditions => {:id => params[:id], :retailer_id => current_user.id})
  end
  
  def update
    @subscription_result = SubscriptionResult.find(params[:id])
    if @subscription_result.subscription.retailer_id = current_user.id
      #my subscription result
      if params[:accept]
	      @subscription_result.accept!
	      Event.log(current_user, @subscription_result)
      else
	      @subscription_result.cancel!
	      Event.log(current_user, @subscription_result)
      end
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to subscription_result_path(@subscription_result.subscription) }
    end

  end
  
  def update_all
    @subscription = Subscription.find(
      :first, :conditions => {:id => params[:subscription_id], :retailer_id => current_user.id}
    )
    @subscription.subscription_results.find(:all, :conditions => {:status => 'new'}).each do |sr|
      if params[:accept]
	sr.accept!
	Event.log(current_user, sr)
      else
	sr.cancel!
	Event.log(current_user, sr)
      end
    end
  end
end
