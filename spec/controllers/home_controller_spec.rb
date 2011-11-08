require 'spec_helper'

describe HomeController do
  context "when user is authenticated" do
    login :user

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "subdomain"
        response.should render_template(:index)
      end
    end
  end

  context "when user is not authenticated" do
    logout :user

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "subdomain"
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
