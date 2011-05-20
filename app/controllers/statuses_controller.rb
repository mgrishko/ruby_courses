class StatusesController < ApplicationController
  def index
    @base_items = current_user.all_fresh_base_items_paginate params[:page]
    @users = current_user.retailers.paginate(:page => params[:page_users], :per_page => 10)
  end
end
