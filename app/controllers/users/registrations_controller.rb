class Users::RegistrationsController < Devise::RegistrationsController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel, :join ]

  #
  #protected
  #
  #def after_sign_up_path_for(resource)
  #  welcome_path
  #end
  #
  #def after_update_path_for(resource)
  #  edit_person_registration_path
  #end
end