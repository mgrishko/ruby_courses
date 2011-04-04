class SubscriptionResultsController < ApplicationController
  before_filter :require_user

  def index
    @results = current_user.subscription_results
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
    end

  end
end
