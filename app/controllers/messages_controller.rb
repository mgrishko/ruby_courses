class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    if current_user.supplier?
      @comments = Comment.paginate(:page => params[:page], :per_page => 10, :conditions => ["comments.user_id !=? and items.user_id = ? and comments.root_id is null", current_user.id, current_user.id], :include => "item", :order => "comments.id desc")
      @message_info = true
    else # current_user.retailer?
      # в разделе выводятся все комментарии поставщиков к айтемам на которые подписан ритейлер.
      # сортировка по убыванию даты
      @comments = Comment.paginate_by_sql([
	"(
	  SELECT c.* FROM comments c
	  INNER JOIN items i ON i.id = c.item_id
	  INNER JOIN base_items bi ON c.base_item_id = bi.id
	  INNER JOIN subscription_details sd ON sd.item_id = c.item_id
	  INNER JOIN subscriptions s ON s.supplier_id=i.user_id
	  WHERE
	    s.retailer_id = ? AND s.specific = 1 AND s.status = 'active'
	    AND (c.user_id = i.user_id or c.user_id = ?)
	    AND c.root_id is null
	    AND
	    IF ((bi.private=1),
	      bi.id = (select r.base_item_id from receivers r where r.base_item_id = bi.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	) UNION (
	  SELECT c.* FROM comments c
	  INNER JOIN items i ON i.id = c.item_id
	  INNER JOIN base_items bi ON c.base_item_id = bi.id 
	  INNER JOIN subscriptions s ON s.supplier_id=i.user_id
	  WHERE
	    s.retailer_id = ? AND s.specific = 0 AND s.status = 'active'
	    AND (c.user_id = i.user_id or c.user_id = ?)
	    AND c.root_id is null
	    AND
	    IF ((bi.private=1),
	      bi.id = (select r.base_item_id from receivers r where r.base_item_id = bi.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	) ORDER BY 1 DESC", current_user.id, current_user.id, current_user.id, current_user.id], :page => params[:page], :per_page => 10)
      @message_info = true
    end
  end
end
