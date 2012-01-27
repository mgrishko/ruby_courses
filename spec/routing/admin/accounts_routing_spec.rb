require "spec_helper"

describe Admin::AccountsController do
  describe "routing" do
    before(:each) do
      @app = Settings.app_subdomain
    end

    it "routes to #index" do
      get("http://#{@app}.example.com/dashboard/accounts").
          should route_to("admin/accounts#index", subdomain: @app)
    end

    it "routes to #show" do
      get("http://#{@app}.example.com/dashboard/accounts/1").
          should route_to("admin/accounts#show", id: "1", subdomain: @app)
    end

    it "routes to #new" do
      get("http://#{@app}.example.com/dashboard/accounts/new").
          should route_to("admin/accounts#show", id: "new", subdomain: @app)
    end

    it "routes to #create" do
      post("http://#{@app}.example.com/dashboard/accounts").should_not be_routable
    end

    it "routes to #edit" do
      get("http://#{@app}.example.com/dashboard/accounts/1/edit").should_not be_routable
    end

    it "routes to #update" do
      put("http://#{@app}.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("http://#{@app}.example.com/dashboard/accounts/1").should_not be_routable
    end

    it "routes to #activate" do
      get("http://#{@app}.example.com/dashboard/accounts/1/activate").should route_to(
              "admin/accounts#activate", id: "1", subdomain: @app)
    end
    
    it "routes to #login_as_owner" do
      get("http://#{@app}.example.com/dashboard/accounts/1/login_as_owner").should route_to(
              "admin/accounts#login_as_owner", id: "1", subdomain: @app)
    end
  end
end
