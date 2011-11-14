require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery
  include ApplicationHelper

  # Checking that CanCan authorization is performed if it's required
  check_authorization if: :require_authorization?

  # Shows access denied alert message and redirects to account home page.
  # When CanCan::AccessDenied exception arises current account is properly initialized.
  #
  # The message can also be customized through internationalization in config/locales/en/responders.en.yml:
  #  en:
  #    unauthorized:
  #      read:
  #        all: "You are not authorized to access this page."
  #      create:
  #        product: "Not allowed to create a new product."
  #
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_url(subdomain: current_account.subdomain), alert: exception.message
  end

  private

  # Checks if CanCan authorization is required for current controller
  #
  # @return [Boolean]
  def require_authorization?
    !(request.subdomain == Settings.app_subdomain || devise_controller?)
  end
end
