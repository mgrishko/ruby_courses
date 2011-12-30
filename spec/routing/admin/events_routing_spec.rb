require "spec_helper"

describe Admin::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/events").
          should route_to("admin/events#index", subdomain: Settings.app_subdomain)
    end

    it "routes to #show" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/events/1").should_not be_routable
    end

    it "routes to #new" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/events/new").should_not be_routable
    end

    it "routes to #create" do
      post("http://#{Settings.app_subdomain}.example.com/dashboard/events").should_not be_routable
    end

    it "routes to #edit" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/events/1/edit").should_not be_routable
    end

    it "routes to #update" do
      put("http://#{Settings.app_subdomain}.example.com/dashboard/events/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("http://#{Settings.app_subdomain}.example.com/dashboard/events/1").should_not be_routable
    end
  end
end
