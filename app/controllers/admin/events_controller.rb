class Admin::EventsController < Admin::BaseController

  # GET /admin/events
  # GET /admin/events.json
  def index
    @events = Event.unscoped.desc(:created_at).limit(Settings.events.recent_max_count_for_admin)
    @events = EventDecorator.decorate(@events)
    respond_with(@events)
  end
end
