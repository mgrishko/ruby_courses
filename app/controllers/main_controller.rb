class MainController < ApplicationController
  before_filter :validate_subdomain
  before_filter :authenticate_user!, if: :current_account?
  before_filter :validate_account_membership!

  #rescue_from CanCan::AccessDenied do |exception|
    #redirect_to new_user_session_url(subdomain: current_account.subdomain)
  #end

  private

  def validate_account_membership!
    redirect_to new_user_session_url(subdomain: current_account.subdomain) unless current_membership?
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