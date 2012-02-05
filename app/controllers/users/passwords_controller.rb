class Users::PasswordsController < Devise::PasswordsController
  layout 'clean'

  protected

  ## The path used after sending reset password instructions
  ## add subdomain
  ##
  #def after_sending_reset_password_instructions_path_for(resource_name)
  #  new_user_password_path
  #end

  # Redirects after password change:
  # * to the first account home page when user has memberships.
  # * to the new user account page when user does not have membership.
  #
  def after_sign_in_path_for(resource)
    if resource.memberships.empty?
      new_users_account_url(subdomain: Settings.app_subdomain)
    else
      home_url(subdomain: resource.memberships.first.account.subdomain)
    end
  end
end
