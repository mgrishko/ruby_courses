class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    if current_user.supplier?
      @comments = Comment.paginate(:page => params[:page], :per_page => 10, :conditions => ["comments.user_id !=? and items.user_id = ? and comments.root_id is null", current_user.id, current_user.id], :include => "item", :order => "comments.id desc")
      @message_info = true
    else # current_user.retailer?
      # в разделе выводятся все комментарии поставщиков к айтемам на которые подписан ритейлер.
      # сортировка по убыванию даты
      @comments = Comment.paginate_by_sql(["(select c.* from comments c inner join items i on i.id = c.item_id inner join subscription_details sd on sd.item_id = c.item_id inner join subscriptions s on s.supplier_id=i.user_id where s.retailer_id = ? and s.specific = 1 and s.status = 'active' and (c.user_id = i.user_id or c.user_id = ?) and c.root_id is null) UNION (select c.* from comments c inner join items i on i.id = c.item_id inner join subscriptions s on s.supplier_id=i.user_id where s.retailer_id = ? and s.specific = 0 and s.status = 'active' and (c.user_id = i.user_id or c.user_id = ?) and c.root_id is null) order by 1 desc", current_user.id, current_user.id, current_user.id, current_user.id], :page => params[:page], :per_page => 10)
      @message_info = true
    end
  end
end
