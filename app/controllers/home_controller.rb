class HomeController < MainController
  skip_authorization_check
  respond_to :html

  # GET /
  def index
    @events = EventDecorator.decorate(
        current_account.events.desc(:created_at).limit(Settings.events.recent_max_count))
  end
end
