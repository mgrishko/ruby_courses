class TagsController < ApplicationController
  before_filter :require_user

  def create
    if params[:tag][:item_id] # tags for items
      @item = Item.find(params[:tag][:item_id])
      #@tag = Tag.find(:first, :conditions => {:name => params[:tag][:name], :user_id => current_user.id })
      #@tag = Tag.find(:first, :conditions => ["clouds.user_id=? and tags.name=?", current_user, params[:tag][:name]])
      @tag = Tag.where(:name => params[:tag][:name], :kind => 1).first
      unless @tag
	@tag = Tag.new(:name => params[:tag][:name], :kind => 1)
	@tag.save
      end
      @cloud = Cloud.new(:user => current_user, :item => @item, :tag => @tag)
      @cloud.save

      @clouds = current_user.clouds.where(:item_id => @item.id)
    else # tags for users
      @user = User.find(params[:tag][:user_id])
      @tag = Tag.where(:name => params[:tag][:name], :kind => 2).firsts
      unless @tag
	@tag = Tag.new(:name => params[:tag][:name], :kind => 2)
	@tag.save
      end
      @cloud = UserTag.new(:author_id => current_user.id, :user_id => @user.id, :tag_id => @tag.id)
      @cloud.save
      @clouds = UserTag.where(:author_id => current_user.id, :user_id => @user.id)
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if params[:kind].to_s == '1'
      @cloud = Cloud.where(:id => params[:id], :user_id => current_user.id).first
      @cloud.destroy
      @clouds = current_user.clouds.where(:item_id => @cloud.item.id)
    else
      @user_tag = UserTag.where(:id => params[:id], :author_id => current_user.id).first
      @user_tag.destroy
      @clouds = UserTag.where(:author_id => current_user.id, :user_id => @user_tag.user.id)
    end
    respond_to do |format|
      format.js
    end
  end

end

