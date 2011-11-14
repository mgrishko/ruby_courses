require 'spec_helper'

describe ApplicationController do

  describe "rescue AccessDenied exception" do
    controller do
      def index
        raise CanCan::AccessDenied.new("Some access denied exception message.")
      end
    end

    login_account_as :viewer

    before(:each) { @account = Account.first }

    it "sets flash alert message" do
      get :index, subdomain: @account.subdomain
      flash[:alert].should eq("Some access denied exception message.")
    end

    it "redirects to account home page" do
      get :index, subdomain: @account.subdomain
      response.should redirect_to(home_url(subdomain: @account.subdomain))
    end
  end
end
