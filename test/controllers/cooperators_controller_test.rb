require 'test_helper'

class CooperatorsControllerTest < ActionController::TestCase
  setup do
    @cooperator = cooperators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cooperators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cooperator" do
    assert_difference('Cooperator.count') do
      post :create, cooperator: { event_id: @cooperator.event_id, nickname: @cooperator.nickname, role: @cooperator.role, user_id: @cooperator.user_id }
    end

    assert_redirected_to cooperator_path(assigns(:cooperator))
  end

  test "should show cooperator" do
    get :show, id: @cooperator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cooperator
    assert_response :success
  end

  test "should update cooperator" do
    patch :update, id: @cooperator, cooperator: { event_id: @cooperator.event_id, nickname: @cooperator.nickname, role: @cooperator.role, user_id: @cooperator.user_id }
    assert_redirected_to cooperator_path(assigns(:cooperator))
  end

  test "should destroy cooperator" do
    assert_difference('Cooperator.count', -1) do
      delete :destroy, id: @cooperator
    end

    assert_redirected_to cooperators_path
  end
end
