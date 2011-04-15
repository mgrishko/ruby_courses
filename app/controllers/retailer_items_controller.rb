class RetailerItemsController < ApplicationController
  before_filter :require_user
  
  def index
    #results = current_user.subscription_results.find(:all, :conditions => {:status => 'accepted'})
    #@base_items = results.any? ? results.map(&:base_item).uniq : []
    @base_items = BaseItem.get_base_items :user_id => current_user.id,
                                          :brand => params[:brand], 
                                          :manufacturer_name => params[:manufacturer_name],
                                          :functional => params[:functional],
                                          :tag => params[:tag],
                                          :retailer => true
    get_filters_data_for_base_items_conditions current_user
  end

end
