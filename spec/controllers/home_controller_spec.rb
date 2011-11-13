require 'spec_helper'

describe HomeController do

  it { should be_kind_of(MainController) }

  context "when user is authenticated" do
    login_account

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
      it "redirects to the user sign in page" do
        get :index, subdomain: "subdomain"
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
