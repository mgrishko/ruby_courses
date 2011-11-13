require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery
  include ApplicationHelper

  # Checking that CanCan authorization is performed if it's required
  check_authorization if: :require_authorization?

  private

  # Checks if CanCan authorization is required for current controller
  #
  # @return [Boolean]
  def require_authorization?
    !(request.subdomain == Settings.app_subdomain || devise_controller?)
  end
end
