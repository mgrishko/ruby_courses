require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "When logging in with correct user/password" do
    setup { authorize_user }
    should_redirect_to "Root url" do 
      root_url
    end 
  end

  context "When logging in with incorrect password" do
    setup {
      authorize_user users(:invalid_user) 
      get :login
    }
    should_respond_with :success
  end

  context "When logging in as admin" do
    setup { authorize_admin } 
    should_redirect_to "root url" do 
      root_url
    end
  end
end
