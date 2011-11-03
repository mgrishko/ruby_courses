require "spec_helper"

describe Admin::DashboardController do
  describe "routing" do

    it "routes to #index" do
      get("http://app.example.com/dashboard").should route_to("admin/dashboard#index", subdomain: "app")
    end

  end
end
