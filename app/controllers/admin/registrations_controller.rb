class Admin::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_admin!
  layout "admin"

  protected

  def after_update_path_for(resource)
    edit_admin_registration_path
  end

end
