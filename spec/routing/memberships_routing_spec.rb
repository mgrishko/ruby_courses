require "spec_helper"

describe MembershipsController do
  describe "routing" do

    it "routes to #index" do
      get("http://subdomain.example.com/memberships").should route_to("memberships#index")
    end

    it "routes to #new" do
      get("http://subdomain.example.com/memberships/new").should_not be_routable
    end

    it "routes to #show" do
      get("http://subdomain.example.com/memberships/1").should_not be_routable
    end

    it "routes to #edit" do
      get("http://subdomain.example.com/memberships/1/edit").should route_to("memberships#edit", :id => "1")
    end

    it "routes to #create" do
      post("http://subdomain.example.com/memberships").should_not be_routable
    end

    it "routes to #update" do
      put("http://subdomain.example.com/memberships/1").should route_to("memberships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("http://subdomain.example.com/memberships/1").should route_to("memberships#destroy", :id => "1")
    end

  end
end
