class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]

  def acknowledgement
  end

  protected

  def after_sign_up_path_for(resource)
    signup_acknowledgement_url(subdomain: "app")
  end

  def after_update_path_for(resource)
    edit_person_registration_path(subdomain: "app")
  end
end
