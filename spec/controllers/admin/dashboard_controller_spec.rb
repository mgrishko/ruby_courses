require 'spec_helper'

describe Admin::DashboardController do
  login :admin

  it { should be_kind_of(Admin::BaseController) }

  describe "GET index" do
    it "renders index template" do
      get :index, subdomain: Settings.app_subdomain
      response.should render_template(:index)
    end
  end
end
