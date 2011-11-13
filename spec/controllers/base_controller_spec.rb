require 'spec_helper'

describe BaseController do
  controller do
    skip_authorization_check

    def index
      head 200
    end
  end

  describe "account membership" do
    login_account as: :viewer

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
        get :index
        response.status.should == 401 # unauthorized
      end
    end
  end

end
