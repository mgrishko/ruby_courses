class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin!
  skip_authorization_check
  respond_to :html

  # GET /dashboard
  def index
  end
end
