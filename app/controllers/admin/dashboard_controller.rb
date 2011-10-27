class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin!

  respond_to :html

  # GET /dashboard
  def index
  end
end
