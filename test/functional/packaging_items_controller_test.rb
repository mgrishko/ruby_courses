require 'test_helper'

class PackagingItemsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:packaging_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_packaging_item
    assert_difference('PackagingItem.count') do
      post :create, :packaging_item => { }
    end

    assert_redirected_to packaging_item_path(assigns(:packaging_item))
  end

  def test_should_show_packaging_item
    get :show, :id => packaging_items(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => packaging_items(:one).id
    assert_response :success
  end

  def test_should_update_packaging_item
    put :update, :id => packaging_items(:one).id, :packaging_item => { }
    assert_redirected_to packaging_item_path(assigns(:packaging_item))
  end

  def test_should_destroy_packaging_item
    assert_difference('PackagingItem.count', -1) do
      delete :destroy, :id => packaging_items(:one).id
    end

    assert_redirected_to packaging_items_path
  end
end
