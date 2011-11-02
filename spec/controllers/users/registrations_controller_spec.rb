require 'spec_helper'

describe Users::RegistrationsController do
  setup_devise_controller_for :user
  with_default_subdomain

  describe "POST create" do
    before(:each) do
      post :create, user: Fabricate.attributes_for(:user)
    end

    it { should redirect_to(signup_acknowledgement_url) }
  end

  describe "GET acknowledgement" do
    login :user

    before(:each) do
      get :acknowledgement
    end

    it { should render_template(:acknowledgement) }
  end
end