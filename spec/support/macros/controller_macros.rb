module ControllerMacros
  include Devise::TestHelpers

  def setup_devise_controller_for(resource)
    before(:each) do
      setup_controller_for_warden
      request.env["devise.mapping"] = Devise.mappings[resource.to_sym]
    end
  end

  # Fabricates resource with a role (if provided) and performs a login.
  #
  # @param [Symbol] resource to fabricate and sign in
  # @param [Symbol] role optional fabricator name modifiers. If provided then tries to fabricate :role_resource
  def login(resource, role = nil)
    resource_with_role = "#{role.blank? ? "" : "#{role.to_s}_"}#{resource.to_s}"
    before(:each) do
      sign_out resource
      current = Fabricate(resource_with_role.to_sym)

      # Stubbing controller method current_<resource>
      @controller.stub("current_#{resource.to_s}".to_sym).and_return(current)
      eval("@current_#{resource.to_s} = current")

      sign_in resource, current
    end
  end

  # Signs out a resource
  #
  # @param [Symbol] resource to sign out
  def logout(resource)
    before(:each) do
      sign_out resource
    end
  end

  def with_subdomain(subdomain = false)
    before(:each) do
      @request.host = subdomain ? "#{subdomain}.test.host" : "test.host"
    end
  end

  # Fabricates user, account and account membership and performs a login as an account role.
  #
  # Examples:
  #
  #   login_account_as :viewer, account: { subdomain: "company" }, user: { email: "user@email.com"}
  #
  # @param [Hash] opts optional, :as option for role, :account for account attributes, :user for user attributes.
  def login_account_as(role, opts = {})
    opts = (opts || {}).with_indifferent_access
    user_attrs = opts.delete(:user) || {}
    account_attrs = opts.delete(:account) || {}

    before(:each) do
      user = Fabricate(:user, user_attrs)

      if role == :owner
        account = Fabricate(:active_account, owner: user)
      else
        account = Fabricate(:active_account, account_attrs)
        Fabricate("#{role.to_s}_membership".to_sym, account: account, user: user)
      end

      # Stubbing helper method current_user
      @controller.stub(:current_user).and_return(user)
      @current_user = user

      # Stubbing helper method current_account
      @controller.stub(:current_account).and_return(account)
      @current_account = account

      sign_in :user, user
    end
  end
end
