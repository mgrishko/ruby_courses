require "spec_helper"

describe Admin::AdminsController do
  describe "routing" do
    context "under #{@app} subdomain" do
      before(:each) do
        @app = Settings.app_subdomain
      end

      it "routes to #index" do
        get("http://#{@app}.example.com/dashboards/admins").should_not be_routable
      end

      it "routes to #show" do
        get("http://#{@app}.example.com/dashboards/admins/1").should_not be_routable
      end

      it "routes to #new" do
        get("http://#{@app}.example.com/dashboards/admins/new").should_not be_routable
      end

      it "routes to #create" do
        post("http://#{@app}.example.com/dashboards/admins").should_not be_routable
      end

      it "routes to #edit" do
        get("http://#{@app}.example.com/dashboard/admins/1/edit").
            should route_to("admin/admins#edit", id: "1", subdomain: "#{@app}")
      end

      it "routes to #update" do
        put("http://#{@app}.example.com/dashboard/admins/1").
            should route_to("admin/admins#update", id: "1", subdomain: "#{@app}")
      end

      it "routes to #destroy" do
        delete("http://#{@app}.example.com/dashboard/admins/1").should_not be_routable
      end
    end

    context "under account subdomain" do
      it "routes to #index" do
        get("http://subdomain.example.com/dashboards/admins").should_not be_routable
      end

      it "routes to #show" do
        get("http://subdomain.example.com/dashboards/admins/1").should_not be_routable
      end

      it "routes to #new" do
        get("http://subdomain.example.com/dashboards/new").should_not be_routable
      end

      it "routes to #create" do
        post("http://subdomain.example.com/dashboards/create").should_not be_routable
      end

      it "routes to #edit" do
        get("http://subdomain.example.com/dashboard/admins/1/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://subdomain.example.com/dashboard/admins").should_not be_routable
      end

      it "routes to #destroy" do
        delete("http://subdomain.example.com/dashboard/admins/1").should_not be_routable
      end
    end
  end
end
