class HomeController < BaseController
  skip_authorization_check
  respond_to :html

  # GET /
  def index
  end
end
