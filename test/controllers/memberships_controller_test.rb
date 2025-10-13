require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @membership = memberships(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get memberships_url
    assert_response :success
  end

  test "should get new" do
    get new_membership_url
    assert_response :success
  end

  test "should create membership" do
    assert_difference('Membership.count') do
      post memberships_url, params: { membership: { distribution_point_id: @membership.distribution_point_id, terminated: @membership.terminated } }
    end

    assert_redirected_to membership_url(Membership.last)
  end

  test "should show membership" do
    get membership_url(@membership)
    assert_response :success
  end

  test "should get edit" do
    get edit_membership_url(@membership)
    assert_response :success
  end

  test "should update membership" do
    patch membership_url(@membership), params: { membership: { distribution_point_id: @membership.distribution_point_id, terminated: @membership.terminated } }
    assert_redirected_to membership_url(@membership)
  end

  test "should destroy membership" do
    membership_to_delete = memberships(:three)
    assert_difference('Membership.count', -1) do
      delete membership_url(membership_to_delete)
    end

    assert_redirected_to memberships_url
  end
end
