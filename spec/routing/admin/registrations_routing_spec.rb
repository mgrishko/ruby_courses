require "spec_helper"

describe Admin::RegistrationsController do
  describe "routing" do
    context "under #{Settings.app_subdomain} subdomain" do
      it "routes to #edit" do
        get("http://#{Settings.app_subdomain}.example.com/dasboard/edit").should route_to("admin/registrations#edit")
      end

      it "routes to #update" do
        put("http://#{Settings.app_subdomain}.example.com/dasboard").should route_to("admin/registrations#update")
      end
    end

    context "under account subdomain" do
      it "routes to #edit" do
        get("http://subdomain.example.com/dashboard/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://subdomain.example.com/dashboard").should_not be_routable
      end
    end

    it "routes to #destroy" do
      delete("http://app.example.com/dashboard").should_not be_routable
    end

    it "routes to #cancel" do
      get("http://app.example.com/dashboard/cancel").should_not be_routable
    end
  end
end
