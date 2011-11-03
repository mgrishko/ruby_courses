require 'spec_helper'

describe Admin::DashboardController do
  with_subdomain "app"

  context "when admin is authenticated" do
    login :admin

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "app"
        response.should render_template(:index)
      end
    end
  end

  context "when admin is not authenticated" do
    logout :admin

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "app"
        response.should redirect_to(new_admin_session_url)
      end
    end
  end

end
