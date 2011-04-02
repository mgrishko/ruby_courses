class SubscriptionResultsController < ApplicationController
  before_filter :require_user

  def index
    @results = current_user.subscription_results
  end

end
