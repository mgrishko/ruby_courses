require "spec_helper"

describe Admin::AccountsController do
  describe "routing" do

    it "routes to #index" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts").
          should route_to("admin/accounts#index", subdomain: Settings.app_subdomain)
    end

    it "routes to #show" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1").
          should route_to("admin/accounts#show", id: "1", subdomain: Settings.app_subdomain)
    end

    it "routes to #new" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/new").
          should route_to("admin/accounts#show", id: "new", subdomain: Settings.app_subdomain)
    end

    it "routes to #create" do
      post("http://#{Settings.app_subdomain}.example.com/dashboard/accounts").should_not be_routable
    end

    it "routes to #edit" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1/edit").should_not be_routable
    end

    it "routes to #update" do
      put("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "routes to #activate" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1/activate").should route_to(
              "admin/accounts#activate", id: "1", subdomain: Settings.app_subdomain)
    end
    
    it "routes to #login_as_owner" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/accounts/1/login_as_owner").should route_to(
              "admin/accounts#login_as_owner", id: "1", subdomain: Settings.app_subdomain)
    end
  end
end
