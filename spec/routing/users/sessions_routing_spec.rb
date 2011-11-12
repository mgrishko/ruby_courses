require "spec_helper"

describe Users::SessionsController do
  describe "routing" do
    context "under account subdomain" do
      it "routes to #new" do
        get("http://subdomain.example.com/signin").should route_to("users/sessions#new")
      end

      it "routes to #create" do
        post("http://subdomain.example.com/signin").should route_to("users/sessions#create")
      end

      it "routes to #destroy" do
        delete("http://subdomain.example.com/signout").should route_to("users/sessions#destroy")
      end
    end

    context "under #{Settings.app_subdomain} subdomain" do
      it "to #new should not be routable" do
        get("http://#{Settings.app_subdomain}.example.com/signin").should_not be_routable
      end

      it "to #create should not be routable" do
        post("http://#{Settings.app_subdomain}.example.com/signin").should_not be_routable
      end

      it "to #destroy should not be routable" do
        delete("http://#{Settings.app_subdomain}.example.com/signout").should_not be_routable
      end
    end
  end
end
