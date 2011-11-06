require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery
  check_authorization if: :require_authorization?

  private

  def require_authorization?
    !(request.subdomain == "app" || devise_controller?)
  end
end
