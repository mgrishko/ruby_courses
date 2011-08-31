class UsersController < ApplicationController

  respond_to :js, :html

  before_filter :set_current_user_id
  load_and_authorize_resource

  # GET /users
  # GET /users.xml
  def index
    @users_grid = initialize_grid @users,
      :order => :created_at,
      :order_direction => 'desc',
      :per_page => PER_PAGE

    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    return redirect_to login_path unless @user
    respond_with(@user)
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    respond_to do |format|
      @user.roles = nil unless can? :set_roles, @user
      @user.active = params[:user][:active] if can? :activate, @user
      if User.count == 0
        @user.roles = ['admin']
        # @user.active = true
        @user.save
      else
        # @user.active = false
        @user.save_without_session_maintenance # and @user.deliver_activation_instructions!
      end
      if @user.valid?
        format.html { redirect_to(@user, :notice => t('users.was_created.')) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      params[:user].delete(:roles) unless can? :set_roles, @user
      @user.active = params[:user][:active] if can? :activate, @user
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => t('users.was_updated.')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url, :notice => t('users.was_deleted.')) }
      format.xml  { head :ok }
    end
  end

  private

  def set_current_user_id
    params[:id] = current_user.id if params[:id] == 'current'
  end

end
