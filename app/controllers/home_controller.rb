class HomeController < MainController
  skip_authorization_check
  respond_to :html

  # GET /
  def index
    @events = EventDecorator.decorate(current_account.events.order(:created_at))
  end
end
