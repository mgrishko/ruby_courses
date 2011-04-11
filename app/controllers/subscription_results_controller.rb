class SubscriptionResultsController < ApplicationController
  before_filter :require_user

  def index
    @results = current_user.subscription_results.sort_by(&:updated_at).reverse.group_by{|sr|sr.subscription}
  end
    
  def show
    @subscription_results = Subscription.first(:conditions => {:id => params[:id], :retailer_id => current_user.id}).subscription_results
  end
  
  def update
    @subscription_result = SubscriptionResult.find(params[:id])
    if @subscription_result.subscription.retailer_id = current_user.id
      #my subscription result
      if params[:accept]
	      @subscription_result.accept!
      else
	      @subscription_result.cancel!
      end
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to subscription_result_path(@subscription_result.subscription) }
    end

  end
end
