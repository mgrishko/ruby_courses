class StatusesController < ApplicationController
  before_filter :require_user

  def index
    return render_404 unless can? :read, Comment
    # FIXME Since there is not such a model Status I have to use Comment. This is wrong and should be fixed
    redirect_to :controller => "subscription_results" if current_user.retailer?
    @base_items = current_user.all_fresh_base_items_paginate params[:page]
    @users = current_user.retailers.paginate(:page => params[:page_users], :per_page => 10)
  end
end
