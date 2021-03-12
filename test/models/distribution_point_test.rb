# == Schema Information
#
# Table name: distribution_points
#
#  id          :integer          not null, primary key
#  name        :string
#  street      :string
#  housenumber :string
#  zipcode     :string
#  city        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#
require 'test_helper'

class DistributionPointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
