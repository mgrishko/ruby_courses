class Admin::BaseController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_admin!
  respond_to :html, :json
end