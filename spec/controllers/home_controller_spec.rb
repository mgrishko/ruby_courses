require 'spec_helper'

describe HomeController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:event)
  end

  context "when user is authenticated" do
    login_account_as :viewer, account: { subdomain: "company" }

    describe "GET index" do
      it "renders index template" do
        get :index, subdomain: "company"
        response.should render_template(:index)
      end
      
      it "assigns all events as @events" do
        account = Account.where(subdomain: "company").first
        event = account.events.create! valid_attributes
        get :index
        assigns(:events).should eq([event])
      end
      
      it "does not show other account events" do
        account = Fabricate(:account, subdomain: "other")
        account.events.create! valid_attributes
        get :index
        assigns(:events).should be_empty
      end
    end
  end

  context "when user is not authenticated" do
    login_account_as :viewer
    logout :user

    describe "GET index" do
      it "redirects to the user sign in page" do
        get :index, subdomain: "subdomain"
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
