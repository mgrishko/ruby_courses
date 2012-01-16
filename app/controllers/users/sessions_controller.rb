class Users::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :sign_out_current_user, :only => [:create]
  layout "clean"

  protected

  # Signs out the current user when he signs in as a different one.
  #
  def sign_out_current_user
    sign_out :user if user_signed_in?
  end

  # Redirects the current user to the requested page that redirected him
  # to login page or to the home page after login.
  #
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # Redirects the current user to login page after logout.
  #
  def after_sign_out_path_for(resource)
    new_session_path(resource)
  end
end
