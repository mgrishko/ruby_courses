require "spec_helper"

describe AccountsController do
  describe "routing" do

    context "within account subdomain" do
      it "routes to #index" do
        get("http://subdomain.example.com/accounts").should_not be_routable
      end

      it "routes to #show" do
        get("http://subdomain.example.com/account").should_not be_routable
      end

      it "routes to #new" do
        get("http://subdomain.example.com/account/new").should_not be_routable
      end

      it "routes to #create" do
        post("http://subdomain.example.com/account").should_not be_routable
      end

      it "routes to #edit" do
        get("http://subdomain.example.com/account/edit").should route_to("accounts#edit")
      end

      it "routes to #update" do
        put("http://subdomain.example.com/account").should route_to("accounts#update")
      end

      it "routes to #delete" do
        delete("http://subdomain.example.com/account").should_not be_routable
      end
    end

    context "within application subdomain" do
      before(:each) do
        @app = Settings.app_subdomain
      end

      it "routes to #index" do
        get("http://#{@app}.example.com/accounts").should_not be_routable
      end

      it "routes to #show" do
        get("http://#{@app}.example.com/account").should_not be_routable
      end

      it "routes to #new" do
        get("http://#{@app}.example.com/account/new").should_not be_routable
      end

      it "routes to #create" do
        post("http://#{@app}.example.com/account").should_not be_routable
      end

      it "routes to #edit" do
        get("http://#{@app}.example.com/account/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://#{@app}.example.com/account").should_not be_routable
      end

      it "routes to #delete" do
        delete("http://#{@app}.example.com/account").should_not be_routable
      end
    end
  end
end
