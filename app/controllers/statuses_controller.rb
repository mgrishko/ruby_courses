class StatusesController < ApplicationController
  before_filter :require_user

  def index
    redirect_to :controller => "subscription_results" if current_user.retailer?
    @base_items = current_user.all_fresh_base_items_paginate params[:page]
    @users = current_user.retailers.paginate(:page => params[:page_users], :per_page => 10)
  end
end
