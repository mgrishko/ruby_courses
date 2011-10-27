require "spec_helper"

describe Admin::DashboardController do
  describe "routing" do

    it "routes to #index" do
      get("/dashboard").should route_to("admin/dashboard#index")
    end

  end
end
