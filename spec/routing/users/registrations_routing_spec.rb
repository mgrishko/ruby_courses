require "spec_helper"

describe Users::RegistrationsController do
  describe "routing" do
    context "under #{Settings.app_subdomain} subdomain" do
      it "routes to #new" do
        get("http://#{Settings.app_subdomain}.example.com/signup").should route_to("users/registrations#new")
      end

      it "routes to #create" do
        post("http://#{Settings.app_subdomain}.example.com/signup").should route_to("users/registrations#create")
      end

      it "routes to #acknowledgement" do
        get("http://#{Settings.app_subdomain}.example.com/signup/thankyou").
            should route_to("users/registrations#acknowledgement")
      end

      it "routes to #edit" do
        get("http://#{Settings.app_subdomain}.example.com/profile/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://#{Settings.app_subdomain}.example.com/profile").should_not be_routable
      end
    end

    context "under account subdomain" do
      it "routes to #new" do
        get("http://subdomain.example.com/profile").should_not be_routable
      end

      it "routes to #create" do
        post("http://subdomain.example.com/profile").should_not be_routable
      end

      it "routes to #acknowledgement" do
        get("http://subdomain.example.com/signup/thankyou").should_not be_routable
      end

      it "routes to #edit" do
        get("http://subdomain.example.com/profile/edit").should route_to("users/registrations#edit")
      end

      it "routes to #update" do
        put("http://subdomain.example.com/profile").should route_to("users/registrations#update")
      end
    end

    it "routes to #destroy" do
      delete("http://app.example.com/profile").should_not be_routable
    end

    it "routes to #cancel" do
      get("http://app.example.com/profile/cancel").should_not be_routable
    end
  end
end
