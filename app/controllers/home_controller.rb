class HomeController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check
  respond_to :html

  # GET /
  def index
  end
end
