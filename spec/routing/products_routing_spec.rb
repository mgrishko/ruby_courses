require "spec_helper"

describe ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("http://subdomain.example.com/products").should route_to("products#index")
    end

    it "routes to #show" do
      get("http://subdomain.example.com/products/1").should route_to("products#show", id: "1")
    end

    it "routes to #new" do
      get("http://subdomain.example.com/products/new").should route_to("products#new")
    end

    it "routes to #create" do
      post("http://subdomain.example.com/products").should route_to("products#create")
    end

    #it "routes to #edit" do
    #  get("http://subdomain.example.com/products/1/edit").should route_to("products#edit", id: "1")
    #end

    #it "routes to #update" do
    #  put("http://subdomain.example.com/products/1").should route_to("products#update", id: "1")
    #end

    #it "routes to #delete" do
    #  delete("http://subdomain.example.com/products/1").should route_to("products#destroy", id: "1")
    #end
  end
end
