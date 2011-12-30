class Users::PasswordsController < Devise::PasswordsController
  layout 'clean'

  protected

  # Redirects the current user to the home page
  # after recover password.
  #
  def after_sign_in_path_for(resource)
    home_url(subdomain: resource.accounts.first.subdomain)
  end
end
