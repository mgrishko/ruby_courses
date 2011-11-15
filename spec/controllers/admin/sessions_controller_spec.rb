require 'spec_helper'

describe Admin::SessionsController do
  setup_devise_controller_for :admin

  before(:each) { Fabricate(:admin, email: "user@example.com", password: "password") }

  describe "POST create" do
    before(:each) do
      post :create, admin: { email: "user@example.com", password: "password" }, subdomain: Settings.app_subdomain
    end

    it { should redirect_to(admin_dashboard_url(subdomain: Settings.app_subdomain)) }
  end

  describe "DELETE destroy" do
    before(:each) do
      delete :destroy, subdomain: Settings.app_subdomain
    end

    it { should redirect_to(new_admin_session_url(subdomain: Settings.app_subdomain)) }
  end
end