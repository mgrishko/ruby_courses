class RetailerItemsController < ApplicationController
  before_filter :require_user
  
  def index
    results = current_user.subscription_results.find(:all, :conditions => {:status => 'accepted'})
    @base_items = results.any? ? results.map(&:base_item) : []
    get_filters_data_for_base_items
  end

end
