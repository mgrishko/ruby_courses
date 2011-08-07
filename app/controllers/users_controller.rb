class UsersController < ApplicationController
  respond_to :js, :html
  before_filter :require_user
  load_and_authorize_resource
  check_authorization
  def show
    @user = current_user
    respond_with(@user)
  end
  
  def edit
    @user = current_user
    respond_with(@user)
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => :edit
    end
  end
end
