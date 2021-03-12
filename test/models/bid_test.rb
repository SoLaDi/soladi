# == Schema Information
#
# Table name: bids
#
#  id              :integer          not null, primary key
#  start_date      :date
#  end_date        :date
#  amount          :decimal(, )
#  shares          :integer
#  contract_signed :boolean
#  membership_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class BidTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
