class UserAttributesController < ApplicationController
  before_filter :require_user
  before_filter :find_user
  
  def show
    @user_attributes = UserAttributes.find(:first, :conditions => {:user_id => @user.id, :author_id => current_user.id})
  end

  def new
    @user_attributes = UserAttributes.new(:user_id => @user.id)
  end

  def create
    if user_attributes_data_exists?
      @user_attributes = UserAttributes.find(:first, :conditions => {:user_id => @user.id, :author_id => current_user.id})
      if @user_attributes
	@user_attributes.update_attributes(params[:user_attributes])
      else
	@user_attributes = UserAttributes.new(:user_id => @user.id, :author_id => current_user.id, :comment => params[:user_attributes][:comment], :inner_id => params[:user_attributes][:inner_id])
	@user_attributes.save
      end
    end
  end
  
  def edit
    @user_attributes = UserAttributes.find(:first, :conditions => {:user_id => @user.id, :author_id => current_user.id})
    render :new
  end
  
  def update
    @user_attributes = UserAttributes.find(:first, :conditions => {:user_id => @user.id, :author_id => current_user.id})
    if user_attributes_data_exists?
      @user_attributes.update_attributes(params[:user_attributes])
    else
      @user_attributes.destroy
    end
  end

private
  def find_user
    @user = User.find(params[:user_attributes][:user_id])
  end
  
  def user_attributes_data_exists? # see retailer_attribute_data_exists? for further collaboration
    p = params[:user_attributes]
    [p[:comment],p[:inner_id]].join.length > 0
  end

end
