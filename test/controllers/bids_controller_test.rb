require "test_helper"

class BidsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @bid = bids(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get bids_url
    assert_response :success
  end

  test "index renders bid price chart with 13-month data" do
    get bids_url
    assert_response :success
    assert_select "canvas#avgBidPriceChart"
    today = Date.today.beginning_of_month
    assert_includes response.body, (today >> -6).strftime("%b %Y")
    assert_includes response.body, (today >> 6).strftime("%b %Y")
  end

  test "should get new" do
    get new_bid_url
    assert_response :success
  end

  test "should create bid" do
    assert_difference("Bid.count") do
      post bids_url, params: { bid: { amount: @bid.amount, contract_signed: @bid.contract_signed, end_date: Date.new(2024, 3, 1), membership_id: 1002, shares: @bid.shares, start_date: Date.new(2023, 4, 1) } }
    end

    assert_redirected_to bid_url(Bid.last)
  end

  test "should show bid" do
    get bid_url(@bid)
    assert_response :success
  end

  test "should get edit" do
    get edit_bid_url(@bid)
    assert_response :success
  end

  test "should update bid" do
    patch bid_url(@bid), params: { bid: { amount: @bid.amount, contract_signed: @bid.contract_signed, end_date: @bid.end_date, membership_id: @bid.membership_id, shares: @bid.shares, start_date: @bid.start_date } }
    assert_redirected_to bid_url(@bid)
  end

  test "should destroy bid" do
    assert_difference("Bid.count", -1) do
      delete bid_url(@bid)
    end

    assert_redirected_to bids_url
  end
end
