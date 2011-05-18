class TagsController < ApplicationController
  before_filter :require_user

  def create
    if params[:tag][:item_id] # tags for items
      @item = Item.find(params[:tag][:item_id])
      #@tag = Tag.find(:first, :conditions => {:name => params[:tag][:name], :user_id => current_user.id })
      #@tag = Tag.find(:first, :conditions => ["clouds.user_id=? and tags.name=?", current_user, params[:tag][:name]])
      @tag = Tag.find(:first, :conditions => {:name => params[:tag][:name], :kind => 1})
      unless @tag
	@tag = Tag.new(:name => params[:tag][:name], :kind => 1)
	@tag.save
      end
      @cloud = Cloud.new(:user => current_user, :item => @item, :tag => @tag)
      @cloud.save

      @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @item.id})
    else # tags for users
      @user = User.find(params[:tag][:user_id])
      @tag = Tag.find(:first, :conditions => {:name => params[:tag][:name], :kind => 2})
      unless @tag
	@tag = Tag.new(:name => params[:tag][:name], :kind => 2)
	@tag.save
      end
      @cloud = UserTag.new(:author_id => current_user.id, :user_id => @user.id, :tag_id => @tag.id)
      @cloud.save
      @clouds = UserTag.find(:all, :conditions => {:author_id => current_user.id, :user_id => @user.id})
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if params[:kind].to_s == '1'
      @cloud = Cloud.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})
      @cloud.destroy
      @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @cloud.item.id})
    else
      @user_tag = UserTag.find(:first, :conditions => {:id => params[:id], :author_id => current_user.id})
      @user_tag.destroy
      @clouds = UserTag.find(:all, :conditions => {:author_id => current_user.id, :user_id => @user_tag.user.id})
    end
    respond_to do |format|
      format.js
    end
  end

end
