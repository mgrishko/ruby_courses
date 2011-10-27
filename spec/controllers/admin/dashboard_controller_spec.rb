require 'spec_helper'

describe Admin::DashboardController do
  login :admin

  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template(:index)
    end
  end

end
