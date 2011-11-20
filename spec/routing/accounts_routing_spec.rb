require "spec_helper"

describe AccountsController do
  describe "routing" do

    it "routes to #edit" do
      get("http://subdomain.example.com/accounts/1/edit").should route_to("accounts#edit", :id => "1")
    end

    it "routes to #update" do
      put("http://subdomain.example.com/accounts/1").should route_to("accounts#update", :id => "1")
    end

  end
end
