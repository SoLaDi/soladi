require 'test_helper'

class DistributionPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @distribution_point = distribution_points(:one)
  end

  test "should get index" do
    get distribution_points_url
    assert_response :success
  end

  test "should get new" do
    get new_distribution_point_url
    assert_response :success
  end

  test "should create distribution_point" do
    assert_difference('DistributionPoint.count') do
      post distribution_points_url, params: { distribution_point: { city: @distribution_point.city, contact_name: @distribution_point.contact_name, housenumber: @distribution_point.housenumber, name: @distribution_point.name, street: @distribution_point.street, zipcode: @distribution_point.zipcode } }
    end

    assert_redirected_to distribution_point_url(DistributionPoint.last)
  end

  test "should show distribution_point" do
    get distribution_point_url(@distribution_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_distribution_point_url(@distribution_point)
    assert_response :success
  end

  test "should update distribution_point" do
    patch distribution_point_url(@distribution_point), params: { distribution_point: { city: @distribution_point.city, contact_name: @distribution_point.contact_name, housenumber: @distribution_point.housenumber, name: @distribution_point.name, street: @distribution_point.street, zipcode: @distribution_point.zipcode } }
    assert_redirected_to distribution_point_url(@distribution_point)
  end

  test "should destroy distribution_point" do
    assert_difference('DistributionPoint.count', -1) do
      delete distribution_point_url(@distribution_point)
    end

    assert_redirected_to distribution_points_url
  end
end
