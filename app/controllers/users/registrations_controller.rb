class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :redirect_authenticated_user, only: [:new, :create]

  layout :layout_name

  def acknowledgement
    head :bad_request unless /signup/.match(request.env["HTTP_REFERER"])
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

  # Redirects authenticated user on new and create actions to new account form
  def redirect_authenticated_user
    if user_signed_in?
      if params[:force_signout]
        sign_out current_user
        redirect_to new_user_registration_url(subdomain: Settings.app_subdomain)
      else
        redirect_to new_users_account_url(subdomain: Settings.app_subdomain)
      end
    end
  end
end
