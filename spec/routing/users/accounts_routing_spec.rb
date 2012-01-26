require "spec_helper"

describe Users::AccountsController do
  describe "routing" do

    context "within application subdomain" do
      before(:each) do
        @app = Settings.app_subdomain
      end

      it "routes to #index" do
        get("http://#{@app}.example.com/signin/accounts").should route_to("users/accounts#index")
      end

      it "routes to #show" do
        get("http://#{@app}.example.com/signup/account/1").should_not be_routable
      end

      it "routes to #new" do
        get("http://#{@app}.example.com/signup/account/new").should route_to("users/accounts#new")
      end

      it "routes to #create" do
        post("http://#{@app}.example.com/signup/account").should route_to("users/accounts#create")
      end

      it "routes to #edit" do
        get("http://#{@app}.example.com/signup/account/1/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://#{@app}.example.com/signup/account/1").should_not be_routable
      end

      it "routes to #delete" do
        delete("http://#{@app}.example.com/signup/account/1").should_not be_routable
      end
    end
    
    context "within account subdomain" do

      it "routes to #index" do
        get("http://subdomain.example.com/signin/accounts").should_not be_routable
      end

      it "routes to #show" do
        get("http://subdomain.example.com/signup/account/1").should_not be_routable
      end

      it "routes to #new" do
        get("http://subdomain.example.com/signup/account/new").should_not be_routable
      end

      it "routes to #create" do
        post("http://subdomain.example.com/signup/account").should_not be_routable
      end

      it "routes to #edit" do
        get("http://subdomain.example.com/signup/account/1/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://subdomain.example.com/signup/account/1").should_not be_routable
      end

      it "routes to #delete" do
        delete("http://subdomain.example.com/signup/account/1").should_not be_routable
      end
    end    

  end
end
