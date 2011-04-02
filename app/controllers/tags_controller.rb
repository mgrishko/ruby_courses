class TagsController < ApplicationController
  before_filter :require_user

  def create
    @item = Item.find(params[:tag][:item_id])
    @tag = @item.tags.find(:first, :conditions => {:name => params[:tag][:name], :user_id => current_user.id })
    unless @tag
      @tag = current_user.tags.new(params[:tag])
      @tag.save
    end
    @tags = Tag.find(:all, :conditions => {:user_id => current_user.id, :item_id => @item.id})
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tag = Tag.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})
    if @tag.user_id = current_user.id
      @tag.destroy
    end
    @tags = Tag.find(:all, :conditions => {:user_id => current_user.id, :item_id => @tag.item.id})
    respond_to do |format|
      format.js
    end
  end

end
