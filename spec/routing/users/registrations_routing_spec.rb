require "spec_helper"

describe Users::RegistrationsController do
  describe "routing" do
    it "routes to #new" do
      get("http://app.example.com/signup").should route_to("users/registrations#new")
    end

    it "routes to #create" do
      post("http://app.example.com/signup").should route_to("users/registrations#create")
    end

    it "routes to #edit" do
      get("http://app.example.com/profile/edit").should route_to("users/registrations#edit")
    end

    it "routes to #update" do
      put("http://app.example.com/profile").should route_to("users/registrations#update")
    end

    it "routes to #destroy" do
      delete("http://app.example.com/users").should route_to("users/registrations#destroy")
    end

    it "routes to #cancel" do
      get("http://app.example.com/users/cancel").should route_to("users/registrations#cancel")
    end

    it "routes to #acknowledgement" do
      get("http://app.example.com/signup/thankyou").should route_to("users/registrations#acknowledgement")
    end
  end
end
