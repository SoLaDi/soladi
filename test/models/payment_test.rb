# == Schema Information
#
# Table name: payments
#
#  id            :integer          not null, primary key
#  month         :date
#  amount        :decimal(, )
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
