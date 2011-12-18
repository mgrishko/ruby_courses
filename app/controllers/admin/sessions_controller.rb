class Admin::SessionsController < Devise::SessionsController
  layout 'clean'

  protected

  # Redirects to admin dashboard after sign in
  def after_sign_in_path_for(resource)
    admin_dashboard_url
  end

  # Redirects to admin dashboard sign in path after sign out
  def after_sign_out_path_for(resource)
    new_admin_session_url
  end
end
