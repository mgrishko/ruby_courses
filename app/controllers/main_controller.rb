class MainController < ApplicationController
  # Should be the first filter, otherwise Membership.current
  # will have non-nil value after signout
  before_filter :set_current_membership
  
  before_filter :validate_subdomain
  before_filter :authenticate_user!, if: :current_account?
  before_filter :validate_account_membership!

  private
  
  # Stores current membership so it can be fetched from all classes in the app
  def set_current_membership
    Membership.current = current_membership
  end

  # Redirects to sign in page if user is not a member of the current accound
  # and stores requested page url in the session so user could be redirected
  # back after successful login.
  #
  def validate_account_membership!
    unless current_membership?
      session["user_return_to"] = request.fullpath
      redirect_to new_user_session_url(subdomain: current_account.subdomain) unless current_membership?
    end
  end

  # ToDo: If user signed in he should be redirected to his account list
  def validate_subdomain
    if request.subdomain == Settings.app_subdomain
      redirect_to(user_signed_in? ? signup_acknowledgement_path : new_user_registration_path)
    else
      head :bad_request unless current_account?
    end
  end

end
