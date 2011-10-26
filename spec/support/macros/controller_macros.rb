module ControllerMacros
  include Devise::TestHelpers

  def login(resource, role = nil)
    resource_with_role = "#{role.blank? ? "" : "#{role.to_s}_"}#{resource.to_s}"
    before(:each) do
      sign_out resource
      current = Fabricate(resource_with_role.to_sym)
      @controller.stub("current_#{resource.to_s}".to_sym).and_return(current)
      eval("@current_#{resource.to_s} = current")
      sign_in resource, current
    end
  end

  def logout(resource)
    before(:each) do
      sign_out resource
    end
  end

  #def with_subdomain(subdomain = false)
  #  subdomain = "#{subdomain}." unless subdomain.blank?
  #  before(:each) do
  #    @request.host = "#{subdomain}test.host"
  #  end
  #end
  #
  #def with_default_subdomain
  #  with_subdomain "www"
  #end
  #
  #def setup_devise_controller_for(resource)
  #  before(:each) do
  #    setup_controller_for_warden
  #    request.env["devise.mapping"] = Devise.mappings[resource.to_sym]
  #  end
  #end

end
