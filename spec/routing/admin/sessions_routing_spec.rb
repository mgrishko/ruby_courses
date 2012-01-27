require "spec_helper"

describe Admin::SessionsController do
  describe "routing" do
    context "under application subdomain" do
      before(:each) do
        @app = Settings.app_subdomain
      end

      it "routes to #new" do
        get("http://#{@app}.example.com/dashboard/sign_in").
            should route_to("admin/sessions#new", subdomain: @app)
      end

      it "routes to #create" do
        post("http://#{@app}.example.com/dashboard/sign_in").
            should route_to("admin/sessions#create", subdomain: @app)
      end

      it "routes to #destroy" do
        delete("http://#{@app}.example.com/dashboard/sign_out").
            should route_to("admin/sessions#destroy", subdomain: @app)
      end
    end

    context "under account subdomain" do
      it "to #new should not be routable" do
        get("http://subdomain.example.com/dashboard/sign_in").should_not be_routable
      end

      it "to #create should not be routable" do
        post("http://subdomain.example.com/dashboard/sign_in").should_not be_routable
      end

      it "to #destroy should not be routable" do
        delete("http://subdomain.example.com/dashboard/sign_out").should_not be_routable
      end
    end
  end
end
