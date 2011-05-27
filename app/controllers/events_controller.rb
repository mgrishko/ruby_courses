class EventsController < ApplicationController
  def index
    #@events = Event.find(:all, :conditions => {:user_id => current_user.id})
    if current_user.supplier?
      @events = Event.paginate_by_sql([
	"
	(SELECT e.* FROM events e
	WHERE
	  e.user_id = ?
	) UNION (
	  SELECT e.* from events e
	  INNER JOIN comments c ON c.id = e.content_id
	  INNER JOIN items i ON i.id = c.item_id
	  WHERE
	    i.user_id = ? AND e.content_type = 'Comment' AND e.user_id != ?
	) UNION (
	  SELECT e.* FROM events e
	  INNER JOIN retailer_attributes ra ON ra.id = e.content_id
	  INNER JOIN items i ON i.id = ra.item_id
	  WHERE
	    i.user_id = ? AND e.content_type = 'RetailerAttribute' AND e.user_id != ?
	) UNION (
	  SELECT e.* FROM events e
	  INNER JOIN subscriptions s ON s.id = e.content_id
	  WHERE s.supplier_id = ? AND e.content_type = 'Subscription' AND e.user_id != ?
	) UNION (
	  SELECT e.* FROM events e
	  INNER JOIN subscription_results sr ON sr.id = e.content_id
	  INNER JOIN base_items bi ON bi.id = sr.base_item_id
	  WHERE
	    bi.user_id = ? AND e.content_type = 'SubscriptionResult' AND e.user_id != ?
	) order by 1 desc
	", current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id
	], :page => params[:page], :per_page => 10)
    else #current_user.retailer?
      @events = Event.paginate_by_sql([
	"
	(SELECT e.* FROM events e
	WHERE
	  e.user_id = ?
	) UNION (
	  SELECT e.* FROM events e
	  INNER JOIN comments c ON c.id = e.content_id
	  INNER JOIN items i ON i.id = c.item_id
	  INNER JOIN base_items bi ON c.base_item_id = bi.id
	  INNER JOIN subscription_details sd ON sd.item_id = c.item_id
	  INNER JOIN subscriptions s ON s.supplier_id=i.user_id
	  WHERE
	    e.content_type = 'Comment' AND e.user_id != ? 
	    AND s.retailer_id = ? AND s.specific = 1 AND s.status = 'active'
	    AND c.user_id = i.user_id
	    AND (
	      (c.root_id is null) OR 
	      (c.root_id is not NULL AND c.root_id = 
		(SELECT c2.id from comments c2 where c2.id = c.root_id AND c2.user_id = ?)
	      )
	    ) AND
	    IF ((bi.private=1),
	      bi.id = (select r.base_item_id from receivers r where r.base_item_id = bi.id and r.user_id = #{current_user.id}),
	      1=1
	    )

	) UNION (
	  SELECT e.* FROM events e
	  INNER JOIN comments c ON c.id = e.content_id
	  INNER JOIN items i ON i.id = c.item_id
	  INNER JOIN base_items bi ON c.base_item_id = bi.id
	  INNER JOIN subscriptions s ON s.supplier_id=i.user_id
	  WHERE
	  e.content_type = 'Comment' AND e.user_id != ?
	  AND s.retailer_id = ? AND s.specific = 0 AND s.status = 'active'
	  AND c.user_id = i.user_id
	  AND (
	    (c.root_id is null) OR 
	    (c.root_id is not NULL AND c.root_id = 
	      (SELECT c2.id from comments c2 where c2.id = c.root_id AND c2.user_id = ?)
	    )
	  ) AND
	  IF ((bi.private=1),
	    bi.id = (select r.base_item_id from receivers r where r.base_item_id = bi.id and r.user_id = #{current_user.id}),
	    1=1
	  )

	) order by 1 desc
	", current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id, current_user.id
      ], :page => params[:page], :per_page => 10)
    end
  end
end
