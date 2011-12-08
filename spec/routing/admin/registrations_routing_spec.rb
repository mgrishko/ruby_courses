require "spec_helper"

describe Admin::RegistrationsController do
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
        get("http://#{Settings.app_subdomain}.example.com/dashboard/edit").should route_to("admin/registrations#edit",
                                                                                          subdomain: "#{Settings.app_subdomain}")
      end

      it "routes to #update" do
        put("http://#{Settings.app_subdomain}.example.com/dashboard").should route_to("admin/registrations#update",
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
        get("http://subdomain.example.com/dashboard/edit").should_not be_routable
      end

      it "routes to #update" do
        put("http://subdomain.example.com/dashboard").should_not be_routable
      end
    end

    it "routes to #destroy" do
      delete("http://#{Settings.app_subdomain}.example.com/dashboard").should route_to('admin/registrations#destroy',
                                                                                      subdomain: "#{Settings.app_subdomain}")
    end

    it "routes to #cancel" do
      get("http://#{Settings.app_subdomain}.example.com/dashboard/cancel").should route_to('admin/registrations#cancel',
                                                                                          subdomain: "#{Settings.app_subdomain}")
    end
  end
end
