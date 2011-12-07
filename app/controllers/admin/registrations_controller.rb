class Admin::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_admin!

  layout "admin"
  #layout :layout_name

  protected

  def after_sign_up_path_for(resource)
    signup_acknowledgement_url(subdomain: Settings.app_subdomain)
  end

  def after_update_path_for(resource)
    edit_admin_registration_path
  end

end
