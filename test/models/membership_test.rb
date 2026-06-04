# == Schema Information
#
# Table name: memberships
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  distribution_point_id :integer          not null
#  terminated            :boolean          default(FALSE), not null
#
require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  # start_date: earliest bid start_date across all bids
  test "start_date returns the earliest bid start date" do
    # membership :one has bids starting 2018-04-01, 2020-04-01, 2021-04-01
    assert_equal Date.new(2018, 4, 1), memberships(:one).start_date
  end

  test "start_date returns nil when the membership has no bids" do
    assert_nil memberships(:three).start_date
  end

  # end_date: latest bid end_date, but only for terminated memberships
  test "end_date returns nil for a non-terminated membership regardless of bids" do
    # membership :one has bids but is not terminated
    assert_nil memberships(:one).end_date
  end

  test "end_date returns the latest bid end date for a terminated membership" do
    # bids inserted with the later bid first (six: 2022-03-01, seven: 2020-03-01)
    # to confirm max_by sorts correctly rather than relying on insertion order
    assert_equal Date.new(2022, 3, 1), memberships(:terminated_with_bids).end_date
  end

  test "end_date returns nil for a terminated membership with no bids" do
    assert_nil memberships(:terminated_without_bids).end_date
  end
end
