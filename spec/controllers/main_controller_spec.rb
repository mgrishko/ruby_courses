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
      it "response should be unauthorized" do
        @controller.stub(:current_membership).and_return(false)
        @controller.stub_chain(:current_account, :subdomain).and_return("company")
        get :index
        #response.status.should == 401 # unauthorized
        response.should redirect_to(new_user_session_url(subdomain: "company"))
      end
    end
  end

end
