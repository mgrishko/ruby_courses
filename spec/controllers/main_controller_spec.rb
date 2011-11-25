require 'spec_helper'

describe MainController do
  controller do
    skip_authorization_check

    def index
      head 200
    end
  end

  describe "account membership" do
    login_account_as :viewer

    context "when valid" do
      it "processes request" do
        @controller.stub(:current_membership).and_return(true)
        get :index
        response.should be_success
      end
    end

    context "when invalid" do
      it "redirects to the login page" do
        @controller.stub(:current_membership).and_return(false)
        @controller.stub_chain(:current_account, :subdomain).and_return("company")
        get :index
        response.should redirect_to(new_user_session_url(subdomain: "company"))
      end
    end
  end

end
