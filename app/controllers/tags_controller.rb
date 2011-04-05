class TagsController < ApplicationController
  before_filter :require_user

  def create
    @item = Item.find(params[:tag][:item_id])
    #@tag = Tag.find(:first, :conditions => {:name => params[:tag][:name], :user_id => current_user.id })
    #@tag = Tag.find(:first, :conditions => ["clouds.user_id=? and tags.name=?", current_user, params[:tag][:name]])
    @tag = Tag.find(:first, :conditions => {:name => params[:tag][:name]})
    unless @tag
      @tag = Tag.new(:name => params[:tag][:name])
      @tag.save
    end
    @cloud = Cloud.new(:user => current_user, :item => @item, :tag => @tag)
    @cloud.save

    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @item.id})
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @cloud = Cloud.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})
    @cloud.destroy
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @cloud.item.id})
    respond_to do |format|
      format.js
    end
  end

end
