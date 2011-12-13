require "spec_helper"

describe Admin::AdminsController do
  describe "routing" do
    context "under #{Settings.app_subdomain} subdomain" do
      #it "routes to #new" do
        #get("http://#{Settings.app_subdomain}.example.com/dashboards/new").should route_to("admin/registrations#new",
                                                                                     #subdomain: "#{Settings.app_subdomain}")
      #end

      #it "routes to #create" do
        #post("http://#{Settings.app_subdomain}.example.com/dashboards/new").should route_to("admin/registrations#create",
                                                                                     #subdomain: "#{Settings.app_subdomain}")
      #end

      it "routes to #edit" do
        get("http://#{Settings.app_subdomain}.example.com/admins/1/edit").should route_to("admin/admins#edit", id: "1",
                                                                                          subdomain: "#{Settings.app_subdomain}")
      end

      it "routes to #update" do
        put("http://#{Settings.app_subdomain}.example.com/admins/1").should route_to("admin/admins#update", id: "1",
                                                                                     subdomain: "#{Settings.app_subdomain}")
      end
    end

    context "under account subdomain" do
      #it "routes to #new" do
        #get("http://subdomain.example.com/dashboards/new").should_not be_routable
      #end

      #it "routes to #create" do
        #post("http://subdomain.example.com/dashboards/create").should_not be_routable
      #end

      it "routes to #edit" do
        get("http://subdomain.example.com/admins/edit/1").should_not be_routable
      end

      it "routes to #update" do
        put("http://subdomain.example.com/admins").should_not be_routable
      end
    end
  end
end
