require "spec_helper"

describe Admin::AccountsController do
  describe "routing" do

    it "routes to #index" do
      get("http://app.example.com/dashboard/accounts").should route_to("admin/accounts#index", subdomain: Settings.app_subdomain)
    end

    it "routes to #show" do
      get("http://app.example.com/dashboard/accounts/1").should route_to("admin/accounts#show", id: "1", subdomain: Settings.app_subdomain)
    end

    it "routes #new to #show (#new should not be routable)" do
      get("http://app.example.com/dashboard/accounts/new").should route_to("admin/accounts#show", id: "new", subdomain: Settings.app_subdomain)
    end

    it "#create should not be routable" do
      post("http://app.example.com/dashboard/accounts").should_not be_routable
    end

    it "#edit should not be routable" do
      get("http://app.example.com/dashboard/accounts/1/edit").should_not be_routable
    end

    it "#update should not be routable" do
      put("http://app.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "#destroy should not be routable" do
      delete("http://app.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "routes to #activate" do
      get("http://app.example.com/dashboard/accounts/1/activate").should route_to(
              "admin/accounts#activate", id: "1", subdomain: Settings.app_subdomain)
    end
  end
end
