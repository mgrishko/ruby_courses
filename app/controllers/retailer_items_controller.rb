class RetailerItemsController < ApplicationController
  def index
    @results = current_user.subscription_results.find(:all, :conditions => {:status => 'accepted'})
  end

end
