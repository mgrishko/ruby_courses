class EventsController < ApplicationController
  def index
    @events = Event.find(:all, :conditions => {:user_id => current_user.id})
  end
end
