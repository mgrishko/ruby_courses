class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]

  layout "front"

  def acknowledgement
  end

  protected

  def build_resource(hash=nil)
    self.resource = super

    account_attrs = params.try(:[], :user).try(:delete, :account)
    Rails.logger.debug "===>#{account_attrs}"
    self.resource.accounts.build(account_attrs) if account_attrs
  end

  def after_sign_up_path_for(resource)
    signup_acknowledgement_url(subdomain: "app")
  end
  #
  #def after_update_path_for(resource)
  #  edit_person_registration_path
  #end
end