require "spec_helper"

describe PhotosController do
  describe "routing" do

    it "routes to #index" do
      get("http://subdomain.example.com/products/1/photos").should_not be_routable
    end

    it "routes to #new" do
      get("http://subdomain.example.com/products/1/photos/new").
          should route_to("photos#show", product_id: "1", id: "new")
    end

    it "routes to #show" do
      get("http://subdomain.example.com/products/1/photos/2").
          should route_to("photos#show", product_id: "1", id: "2")
    end

    it "routes to #edit" do
      get("http://subdomain.example.com/products/1/photos/1/edit").should_not be_routable
    end

    it "routes to #create" do
      post("http://subdomain.example.com/products/1/photos").
          should route_to("photos#create", product_id: "1")
    end

    it "routes to #update" do
      put("http://subdomain.example.com/products/1/photos/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("http://subdomain.example.com/products/1/photos/1").
          should route_to("photos#destroy", id: "1", product_id: "1")
    end

  end
end
