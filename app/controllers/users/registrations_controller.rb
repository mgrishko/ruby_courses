class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_user!, :except => [ :new, :create, :cancel ]

  layout :layout_name

  def acknowledgement
  end

  protected

  def after_sign_up_path_for(resource)
    signup_acknowledgement_url(subdomain: Settings.app_subdomain)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def layout_name
    %w(new create acknowledgement cancel).include?(action_name) ? "clean" : "application"
  end
end
