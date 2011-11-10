require 'spec_helper'

describe Users::SessionsController do
  setup_devise_controller_for :user
  with_subdomain "company"

  describe "POST create" do
    before(:each) do
      user = Fabricate(:user, email: "user@example.com", password: "password")
      account = Fabricate(:account, owner: user, subdomain: "company")
      account.activate

      post :create, user: { email: "user@example.com", password: "password" }
    end

    it { should redirect_to(home_url(subdomain: "company")) }
  end
end