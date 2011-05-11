class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @item = Item.find(params[:comment][:item_id])
    @comment = current_user.comments.new(params[:comment])
    @item.comments << @comment
    respond_to do |format|
      format.js
    end
  end

end
