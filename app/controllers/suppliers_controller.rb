class SuppliersController < ApplicationController
  before_filter :require_user

  def index
    @users = User.paginate :page => params[:page], :per_page => 10
  end
end
