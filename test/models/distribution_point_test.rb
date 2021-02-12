# == Schema Information
#
# Table name: distribution_points
#
#  id           :integer          not null, primary key
#  name         :string
#  street       :string
#  housenumber  :string
#  zipcode      :string
#  city         :string
#  contact_name :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class DistributionPointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
