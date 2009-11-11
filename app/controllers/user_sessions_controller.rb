class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:show, :create]
  before_filter :require_user, :only => [:destroy]
 
  def login
    if params[:user_session]
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Успешно вошли"
        redirect_to root_url
      end
    else
      @user_session = UserSession.new
    end
  end
 
  def logout
    if current_user_session 
      current_user_session.destroy
      flash[:notice] = "Успешно вышли"
    end
    redirect_to :action => :login
  end
end
