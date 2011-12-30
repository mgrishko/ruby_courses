class Admin::EventsController < Admin::BaseController

  # GET /admin/events
  # GET /admin/events.json
  def index
    respond_with(@events)
  end
end
