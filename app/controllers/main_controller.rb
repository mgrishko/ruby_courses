class MainController < ApplicationController
  before_filter :validate_subdomain
  before_filter :authenticate_user!, if: :current_account?
  before_filter :validate_account_membership!

  private

  # Responds with 401 Unauthorized status code if current user does not a member of current account.
  def validate_account_membership!

    # Fix me!!! We should show login form for signed in user unless current_membership (ticket 364)
    head :unauthorized unless current_membership?
  end

  # Fix me!!! If user signed in he should be redirected to his account list
  def validate_subdomain
    if request.subdomain == Settings.app_subdomain
      redirect_to(user_signed_in? ? signup_acknowledgement_path : new_user_registration_path)
    else
      head :bad_request unless current_account?
    end
  end
end