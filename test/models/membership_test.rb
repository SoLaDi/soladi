# == Schema Information
#
# Table name: memberships
#
#  id                    :integer          not null, primary key
#  startDate             :date
#  endDate               :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  distribution_point_id :integer          not null
#
require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
