require "spec_helper"

describe Admin::EventsController do
  describe "routing" do
    before(:each) do
      @app = Settings.app_subdomain
    end

    it "routes to #index" do
      get("http://#{@app}.example.com/dashboard/events").
          should route_to("admin/events#index", subdomain: @app)
    end

    it "routes to #show" do
      get("http://#{@app}.example.com/dashboard/events/1").should_not be_routable
    end

    it "routes to #new" do
      get("http://#{@app}.example.com/dashboard/events/new").should_not be_routable
    end

    it "routes to #create" do
      post("http://#{@app}.example.com/dashboard/events").should_not be_routable
    end

    it "routes to #edit" do
      get("http://#{@app}.example.com/dashboard/events/1/edit").should_not be_routable
    end

    it "routes to #update" do
      put("http://#{@app}.example.com/dashboard/events/1").should_not be_routable
    end

    it "routes to #destroy" do
      delete("http://#{@app}.example.com/dashboard/events/1").should_not be_routable
    end
  end
end
