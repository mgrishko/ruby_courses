require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery

  helper_method :current_account

  # Checking that CanCan authorization is performed if it's required
  check_authorization if: :require_authorization?

  protected

  # Prepares ability for current membership.
  #
  # @return [MembershipAbility] membership ability for current user in current account.
  def current_ability
    @current_ability ||= MembershipAbility.new(current_membership)
  end

  # Prepares account membership if current user has membership for current account and account is not nil.
  # Otherwise returns nil.
  #
  # @return [Membership, nil] membership on current user in current account.
  def current_membership
    @current_membership ||= begin
      current_user && current_account ? current_account.memberships.where(user_id: current_user.id).first : nil
    end
  end

  # Checks if user has membership in current account
  #
  # @return [Boolean]
  def current_membership?
    !!current_membership
  end

  # Returns account if account can be found by current request subdomain. Otherwise returns nil.
  #
  # @return [Account, nil] account for current subdomain if account subdomain or nil.
  def current_account
    unless request.subdomain == Settings.app_subdomain
      @current_account ||= Account.where(subdomain: request.subdomain, state: "active").first
    end
  end

  # Checks if exists active account with request subdomain
  #
  # @return [Boolean]
  def current_account?
    !!current_account
  end

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
