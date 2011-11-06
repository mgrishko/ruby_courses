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


  context "when user is authenticated" do
    login :user

    describe "GET edit" do

      it "renders edit template" do
        get :edit
        response.should render_template(:edit)
      end
    end

    describe "PUT edit" do

      describe "failure" do

        before(:each) do
          attr = { :first_name => "", :last_name => "", :time_zone => "", :email => "",
                   :locale => "", :current_password => "" }
        end

        it "should not change user" do
          #pending
        end

      end

      describe "success" do
        before(:each) do
          @attr = { :first_name => "name", :last_name => "last_name", :time_zone => "Kyiv",
                   :email => "email@dot.com", :locale => "en", :current_password => "password" }
        end

        it "should change the user's attributes" do
          #pending
        end
      end
    end
  end

  context "when user is authenticated" do
    logout :user

    describe "GET edit" do

      it "renders edit template" do
        get :edit
        response.should_not render_template(:edit)
      end
    end
  end
end
