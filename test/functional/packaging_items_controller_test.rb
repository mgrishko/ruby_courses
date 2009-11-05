require 'test_helper'

class PackagingItemsControllerTest < ActionController::TestCase
  should "get index" do
    get :index, :article_id => article_parent
    assert_response :success
  end

  def article_parent
    articles(:parent)
  end

  def article_not_a_parent
    articles(:not_a_parent)
  end

  should "success on getting new" do
    get :new, :article_id => article_parent
    assert_response :success
  end

  should "success on packaging item creating" do
    assert_difference('PackagingItem.count', +1) do
      post :create, :packaging_item => { }, :article_id => article_parent
    end
  end

  should "success on packaging item showing" do
    get :show, :id => packaging_items(:child_of_an_article).id, :article_id => article_parent
    assert_response :success
  end

  should "get edit" do
    get :edit, :id => packaging_items(:child_of_an_article).id, :article_id => article_parent
    assert_response :success
  end

  should "success on updating" do 
    put :update, :id => packaging_items(:child_of_an_article).id, :article_id => article_parent, :packaging_item => { }
  end

  should "update packaging item" do
    put :update, :id => packaging_items(:child_of_an_article), :article_id => article_parent
  end

  should "destroy packaging item" do
    assert_difference('PackagingItem.count', -1) do
      get :destroy, :id => packaging_items(:child_of_an_article), :article_id => article_parent
    end

    assert_redirected_to article_packaging_items_path article_parent
  end

  should "throw error when article_id not given" do

    assert_raise ActiveRecord::RecordNotFound do
      get :index
    end

    assert_raise ActiveRecord::RecordNotFound do
      get :new
    end

    assert_raise ActiveRecord::RecordNotFound do
      post :create, :packaging_item => { }
    end

    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => packaging_items(:one).id
    end

    assert_raise ActiveRecord::RecordNotFound do
      get :edit, :id => packaging_items(:one).id
    end

    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, :id => packaging_items(:one).id
    end

    assert_raise ActiveRecord::RecordNotFound do
      put :update, :id => packaging_items(:one).id, :packaging_item => { }
    end
  end

  should "throw error when article is not a parent" do

    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => packaging_items(:child_of_an_article).id, :article_id => article_not_a_parent
    end

    assert_raise ActiveRecord::RecordNotFound do
      get :edit, :id => packaging_items(:child_of_an_article), :article_id => article_not_a_parent
    end

    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, :id => packaging_items(:one).id, :article_id => article_not_a_parent
    end

    assert_raise ActiveRecord::RecordNotFound do
      put :update, :id => packaging_items(:one).id, :article_id => article_not_a_parent
    end
  end

  should "handle correct when article is not a parent" do
    get :new, :article_id => article_not_a_parent
    assert_response :success

    get :index, :article_id => article_not_a_parent
    assert_response :success

    post :create, :packaging_item => { }, :article_id => article_not_a_parent
    assert_redirected_to [article_not_a_parent, assigns(:packaging_item)]
  end
end
