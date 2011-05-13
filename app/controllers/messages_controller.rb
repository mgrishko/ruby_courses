class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    @comments = Comment.paginate(:page => params[:page], :per_page => 10, :conditions => ["comments.user_id !=? and items.user_id = ? and comments.root_id is null", current_user.id, current_user.id], :include => "item", :order => "comments.id desc")
    @message_info = true
  end
end
