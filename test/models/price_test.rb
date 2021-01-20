# == Schema Information
#
# Table name: prices
#
#  id            :integer          not null, primary key
#  month         :integer
#  year          :integer
#  shares        :integer
#  amount        :decimal(, )
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
