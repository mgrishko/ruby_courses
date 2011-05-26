class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @message_info = params[:comment][:message_info]
    params[:comment].delete(:message_info)
    @item = Item.find(params[:comment][:item_id])
    @base_item = BaseItem.find(params[:comment][:base_item_id])
    @comment = current_user.comments.new(params[:comment])
    if params[:new] && params[:comment][:content].to_s.length > 0
      @comment.save
      Event.log(current_user, @comment)
    end
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
    @message_info = params[:comment][:message_info]
    #@comment = current_user.comments.new(params[:comment])
  end
end
