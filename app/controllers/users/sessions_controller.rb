class Users::SessionsController < Devise::SessionsController

  layout "clean"

  protected

  #def after_sign_in_path_for(resource)
  #  home_path
  #end
end