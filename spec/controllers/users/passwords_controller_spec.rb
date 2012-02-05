require 'spec_helper'

describe Users::PasswordsController do
  setup_devise_controller_for :user
  with_subdomain "app"

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:user).merge(password: "password", password_confirmation: "password")
  end

  describe "POST update" do
    context "when user has membership" do
      login_account_as :viewer

      it "should redirect to the first user membership" do
        account = @current_user.memberships.first.account
        post :create, user: valid_attributes, subdomain: Settings.app_subdomain
        response.should redirect_to(home_url(subdomain: account.subdomain))
      end
    end

    context "when user does not have membership" do
      login :user

      it "should redirect to the new user account" do
        post :create, user: valid_attributes, subdomain: Settings.app_subdomain
        response.should redirect_to(new_users_account_url(subdomain: Settings.app_subdomain))
      end
    end
  end
end
