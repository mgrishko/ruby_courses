require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery
  check_authorization if: :require_authorization?
  
  protected
  
  def current_ability
    @current_ability ||= MembershipAbility.new(current_membership)
  end

  # Returns account membership if current user has membership for current account and account is not nil.
  # Otherwise returns nil.
  def current_membership
    @current_membership ||= begin
      current_user && current_account ? current_account.memberships.where(user_id: current_user.id).first : nil
    end
  end

  # Returns account if account can be found by current request subdomain. Otherwise returns nil.
  #
  def current_account
    unless request.subdomain == "app"
      @current_account ||= Account.where(subdomain: request.subdomain).first
    end
  end

  private

  def require_authorization?
    !(request.subdomain == "app" || devise_controller?)
  end
end
