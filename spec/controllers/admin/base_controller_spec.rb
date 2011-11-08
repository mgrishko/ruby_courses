require 'spec_helper'

describe Admin::BaseController do
  controller do
    def index
      head 200
    end
  end

  context "when admin is authenticated" do
    login :admin

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "app"
        response.should be_success
      end
    end
  end

  context "when admin is not authenticated" do
    logout :admin
    with_subdomain "app"

    describe "GET index" do
      it "redirects to dashboard sign in page" do
        get :index, subdomain: "app"
        response.should redirect_to(new_admin_session_url)
      end
    end
  end

end
