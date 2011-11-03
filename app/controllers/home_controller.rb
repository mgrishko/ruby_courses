class HomeController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  # GET /
  def index
  end
end
