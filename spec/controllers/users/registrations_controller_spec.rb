require 'spec_helper'

describe Users::RegistrationsController do
  setup_devise_controller_for :user

  describe "POST create" do
    before(:each) do
      post :create, user: Fabricate.attributes_for(:user), subdomain: "app"
    end

    it { should redirect_to(signup_acknowledgement_url(subdomain: "app")) }
  end

  describe "GET acknowledgement" do
    login :user

    before(:each) do
      get :acknowledgement, subdomain: "app"
    end

    it { should render_template(:acknowledgement) }
  end
end