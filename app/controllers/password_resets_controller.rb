class PasswordResetsController < ApplicationController

  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  # GET /password_resets/new
  # GET /password_resets/new.xml
  def new
  end

  # GET /password_resets/1/edit
  def edit
  end

  # POST /password_resets
  # POST /password_resets.xml
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = t 'password_resets.instructions_are_sent'
      redirect_to login_path
    else
      flash.now[:error] = t 'password_resets.no_email', :email => params[:email]
      render :action => :new
    end
  end

  # PUT /password_resets/1
  # PUT /password_resets/1.xml
  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    return unless @user
    if @user.save
      flash[:notice] = t 'password_resets.updated'
      redirect_to @user
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = t 'password_resets.no_account'
      redirect_to root_url
    end
  end

end
