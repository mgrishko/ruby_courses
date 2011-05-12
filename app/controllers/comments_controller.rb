class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @item = Item.find(params[:comment][:item_id])
    @base_item = BaseItem.find(params[:comment][:base_item_id])
    @comment = current_user.comments.new(params[:comment])
    @comment.save if params[:new]
    #@item.comments << @comment
    respond_to do |format|
      format.js
    end
  end
  
  def reply
    @item = Item.find(params[:comment][:item_id])
    @base_item = BaseItem.find(params[:comment][:base_item_id])
    @p = Comment.find(:first, :conditions => {:id => params[:comment][:parent_id]})
    @r = Comment.find(params[:comment][:root_id])
    #@comment = current_user.comments.new(params[:comment])
  end
end
