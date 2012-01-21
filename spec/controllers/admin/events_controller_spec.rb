require 'spec_helper'

describe Admin::EventsController do
  login :admin
  
  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:event)
  end
  
  it { should be_kind_of(Admin::BaseController) }

  context "when user is authenticated" do
    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: Settings.app_subdomain
        response.should render_template(:index)
      end
      
      it "assigns all events as @events" do
        account = Fabricate(:account, subdomain: "company")
        event = account.events.create! valid_attributes
        get :index, subdomain: Settings.app_subdomain
        assigns(:events).first.should be_kind_of(EventDecorator)
      end
    end
  end
end
