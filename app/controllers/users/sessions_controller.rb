class Users::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :signout_current_user, :only => [:create]
  layout "clean"

  protected

  # Signs out the current user when he signs in as a different one.
  #
  def signout_current_user
    user_return_to = session[:user_return_to]
    warden.logout()
    session["user_return_to"] = user_return_to
  end

  # Redirects the current user to the requested page that redirected him
  # to login page or to the home page after login.
  #
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
