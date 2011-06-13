class EventsController < ApplicationController
  #FIXME: refactoring needed
  def index
    if current_user.supplier?

      user_events =current_user.events

      comments = current_user.item_comments.to_ids
      comment_events = Event.comments.where(:content_id => comments)

      retailer_attributes = current_user.item_retailer_attributes.to_ids
      retailer_events =Event.retailer_attributes.where(:content_id => retailer_attributes)

      subscriptions = current_user.subscribers.to_ids
      subscription_events = Event.subscriptions.where(:content_id => subscriptions)

      subscription_results = current_user.base_item_subscription_results.to_ids
      subscription_result_events = Event.subscription_results.where(:content_id => subscription_results)

      # union results and sort them descending by id
      events = (user_events | comment_events | retailer_events | subscription_events | subscription_result_events).sort{|a,b| b.id <=> a.id}

      @events = events.paginate :page => params[:page], :per_page => 10

    else #current_user.retailer?

      user_events =current_user.events

      comments = current_user.comments
      comment_events = Event.comments.where(:content_id => comments)

      events = (comment_events | user_events).compact.sort{|a,b| b.id <=> a.id}
      @events = events.paginate :page => params[:page], :per_page => 10

    end
  end
end

