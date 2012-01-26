require 'spec_helper'

describe Users::RegistrationsController do
  setup_devise_controller_for :user
  with_subdomain "app"

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:user)
    @attrs[:accounts_attributes] = { "0" => Fabricate.attributes_for(:account, owner: nil) }
    @attrs
  end

  describe "GET new" do
    context "when unauthenticated user" do
      logout :user

      it "renders a new user form" do
        get :new
        response.should render_template(:new)
      end
    end

    context "when authenticated user" do
      login :user

      context "unless sign out forced" do
        it "redirects to new user account form" do
          get :new
          response.should redirect_to(new_users_account_url(subdomain: Settings.app_subdomain))
        end
      end

      context "if sign out forced" do
        it "redirects to new user form" do
          get :new, force_signout: true
          response.should redirect_to(new_user_registration_url(subdomain: Settings.app_subdomain))
        end
      end
    end
  end

  describe "POST create" do
    context "when unauthenticated user" do
      logout :user

      it "should redirect to acknowledgement" do
        post :create, user: valid_attributes, subdomain: Settings.app_subdomain
        should redirect_to(signup_acknowledgement_url(subdomain: Settings.app_subdomain))
      end
    end

    context "when authenticated user" do
      login :user

      it "redirects to new user account form" do
        post :create, user: valid_attributes, subdomain: Settings.app_subdomain
        response.should redirect_to(new_users_account_url(subdomain: Settings.app_subdomain))
      end
    end
  end

  describe "GET acknowledgement" do
    login :user

    context "when redirected from user signup form" do
      before(:each) do
        @request.env['HTTP_REFERER'] = 'http://app.test.host/signup'
        get :acknowledgement, subdomain: Settings.app_subdomain
      end

      it { should render_template(:acknowledgement) }
    end

    context "when redirected from new account form" do
      before(:each) do
        @request.env['HTTP_REFERER'] = 'http://app.test.host/signup/account'
        get :acknowledgement, subdomain: Settings.app_subdomain
      end

      it { should render_template(:acknowledgement) }
    end

    context "when referer is not a signup form" do
      before(:each) do
        @request.env['HTTP_REFERER'] = 'http://app.test.host/some-other-page'
      end

      it "responds with bad request status code" do
        get :acknowledgement, subdomain: Settings.app_subdomain
        response.status.should == 400 # bad request
      end
    end
  end
end
