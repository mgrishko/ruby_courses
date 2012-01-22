class Users::PasswordsController < Devise::PasswordsController
  layout 'clean'

  protected

  # The path used after sending reset password instructions
  # add subdomain
  #
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_password_path
  end

  # Redirects the current user to the home page
  # after recover password.
  #
  def after_sign_in_path_for(resource)
    home_url(subdomain: resource.accounts.first.subdomain)
  end
end
