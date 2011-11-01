class Users::RegistrationsController < Devise::RegistrationsController
  #before_filter :set_current_ability_for_user
  #before_filter :check_permissions, :only => [:new, :create, :destroy]
  #skip_before_filter :require_no_authentication
  #
  #protected
  #
  #def after_update_path_for(resource)
  #  edit_user_registration_path
  #end
  #
  #def check_permissions
  #  authorize! :create, resource
  #end
end