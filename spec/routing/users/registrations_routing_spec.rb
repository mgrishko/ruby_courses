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

    it "#destroy should not be routable" do
      delete("http://app.example.com/profile").should_not be_routable
    end

    it "#cancel should not be routable" do
      get("http://app.example.com/profile/cancel").should_not be_routable
    end

    it "routes to #acknowledgement" do
      get("http://app.example.com/signup/thankyou").should route_to("users/registrations#acknowledgement")
    end
  end
end
