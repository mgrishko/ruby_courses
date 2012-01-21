require 'spec_helper'

describe Users::RegistrationsController do
  setup_devise_controller_for :user

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:user)
    @attrs[:accounts_attributes] = { "0" => Fabricate.attributes_for(:account, owner: nil) }
    @attrs
  end

  describe "POST create" do
    it "should redirect to acknowledgement" do
      post :create, user: valid_attributes, subdomain: Settings.app_subdomain
      should redirect_to(signup_acknowledgement_url(subdomain: Settings.app_subdomain))
    end
    
    it "should create account created event" do
      expect {
        post :create, user: valid_attributes, subdomain: Settings.app_subdomain
      }.to change(Event.unscoped, :count).by(1)
      
      event = Event.unscoped.desc(:created_at).first
      event.action_name.should == "create"
      event.trackable.should be_kind_of(Account)
    end
  end

  describe "GET acknowledgement" do
    login :user

    before(:each) do
      get :acknowledgement, subdomain: Settings.app_subdomain
    end

    it { should render_template(:acknowledgement) }
  end
end
