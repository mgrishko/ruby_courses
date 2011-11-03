require "spec_helper"

describe HomeController do
  describe "routing" do

    it "routes to #index" do
      get("http://app.example.com/").should route_to("home#index")
    end
  end
end
