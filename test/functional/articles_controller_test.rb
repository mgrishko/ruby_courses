require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get index" do
    authorize_user
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    authorize_user
    get :new
    assert_response :success
  end

  test "should create article" do
    authorize_user

    assert_difference('Article.count', 1) do
      post :create, :article => Factory.build(:article).attributes
    end

    assert_equal assigns(:article).user_id, 123
    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    authorize_user
    get :show, :id => articles(:one).id
    assert_response :success
  end

  test "should get edit" do
    authorize_user
    get :edit, :id => articles(:one).id
    assert_response :success
  end

  test "should update article" do
    authorize_user
    put :update, :id => articles(:one).to_param, :article => Factory.build(:article).attributes
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    authorize_user

    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:owned_by_user).id
    end

    assert_redirected_to articles_path
  end

  test "should send email on creating " do 
    authorize_user
    post :create, :article => { :gtin => 31 }
  end
end
