require 'spec_helper'

describe MainController do
  controller do
    skip_authorization_check

    def index
      head 200
    end
  end

  # Clears stored current membership in the current thread
  before(:each) do
    Membership.current = nil
  end

  describe "subdomain" do
    context "application subdomain" do
      with_subdomain Settings.app_subdomain

      before(:each) do
        @controller.stub(:current_account).and_return(nil)
      end

      context "when user is not signed in" do
        it "redirects to user sign up page" do
          get :index
          response.should redirect_to(new_user_registration_url(subdomain: Settings.app_subdomain))
        end
      end

      context "when user is signed in" do
        login_account_as :viewer

        it "redirects to new account page" do
          get :index
          response.should redirect_to(new_users_account_url(subdomain: Settings.app_subdomain))
        end
      end
    end

    context "account" do
      login_account_as :viewer

      context "when valid" do
        it "response should be success" do
          account = Account.first
          @controller.stub(:current_account, :subdomain).and_return(account.subdomain)
          @controller.stub(:current_membership).and_return(true)
          get :index
          response.should be_success
        end
      end

      context "when invalid" do
        it "responds with bad request status code" do
          @controller.stub(:current_account).and_return(nil)
          get :index
          response.status.should == 400 # bad request
        end
      end
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
  
  describe "current membership" do
    context "when user is signed in" do
      login_account_as :viewer
      
      it "should set Membership.current" do
        get :index
        Membership.current.should_not be_nil
      end
    end
    
    context "when user is not signed in" do
      it "should not set Membership.current" do
        get :index
        Membership.current.should be_nil
      end
    end
  end
end
