require "spec_helper"

describe Users::SessionsController do
  describe "routing" do
    context "under account subdomain" do
      it "routes to #new" do
        get("http://subdomain.example.com/signin").should route_to("users/sessions#new")
      end

      it "routes to #create" do
        post("http://subdomain.example.com/signin").should route_to("users/sessions#create")
      end

      it "routes to #destroy" do
        delete("http://subdomain.example.com/signout").should route_to("users/sessions#destroy")
      end
    end

    context "under application subdomain" do
      before(:each) do
        @app = Settings.app_subdomain
      end

      it "routes to #new" do
        get("http://#{@app}.example.com/signin").should_not be_routable
      end

      it "routes to #create" do
        post("http://#{@app}.example.com/signin").should_not be_routable
      end

      it "routes to #destroy" do
        delete("http://#{@app}.example.com/signout").should_not be_routable
      end
    end
  end
end
