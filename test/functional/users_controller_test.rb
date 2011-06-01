require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "When GET and not authorized" do
    setup {
      get :index
      get :new
      get :edit, :id => users(:one).to_param
      post :create, :user => {:gln =>  '1000000000147', :password => 'asdf', :password_confirmation => 'asdf'}
      delete :destroy, :id => users(:one).to_param
    }
    should_error_unauthorized
  end

  context "When GET and authorized" do
    setup do
      get :index
      get :new
      get :edit, :id => users(:one).to_param
      post :create, :user => {:gln =>  '1000000000154', :password => 'asdf', :password_confirmation => 'asdf'}
      delete :destroy, :id => users(:one).to_param
    end
    should_error_not_admin
  end

  context "should open all for admin" do
    setup do
      authorize_admin
      get :index
      get :new
      get :edit, :id => users(:one).to_param
      #post :create, :user => {:gln =>  '1000000000161', :password => 'asdf', :password_confirmation => 'asdf'}
      #delete :destroy, :id => users(:one).to_param
    end

    should_not_error_not_admin
  end

  context "creating user" do
    setup { 
      authorize_admin 
      post :create, :user => {:gln => '1000000000123', :password => 'asdfjkl', :password_confirmation => 'asdfjkl' }
    }

    should_change "User.count", :by => 1
    should_redirect_to "user page" do
      user_path(User.last)
    end
  end

  test "should show user" do
    authorize_admin

    get :show, :id => users(:one).to_param
    assert_response  :success
  end

  test "should get edit" do
    authorize_admin

    get :edit, :id => users(:one).to_param
    assert_response :success
  end

  test "should update user" do
    authorize_admin

    put :update, :id => users(:one).to_param, :user => { :gln => '0000000000131' }

    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    authorize_admin

    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).to_param
    end

    assert_redirected_to users_path
  end
end