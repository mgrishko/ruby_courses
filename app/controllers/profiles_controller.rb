class ProfilesController < ApplicationController
  before_filter :require_user

  def show
    @user = User.find(params[:id])
    @user_attributes = UserAttributes.find(:first, :conditions => {:user_id => @user.id, :author_id => current_user.id})
    @clouds = UserTag.find(:all, :conditions => {:user_id => @user.id, :author_id => current_user.id})
  end
end
