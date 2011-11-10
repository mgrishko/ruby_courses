require "spec_helper"

describe Users::SessionsController do
  describe "routing" do
    it "routes to #new" do
      get("http://app.example.com/signin").should route_to("users/sessions#new")
    end

    it "routes to #create" do
      post("http://app.example.com/signin").should route_to("users/sessions#create")
    end

    it "routes to #destroy" do
      delete("http://app.example.com/signout").should route_to("users/sessions#destroy")
    end
  end
end
