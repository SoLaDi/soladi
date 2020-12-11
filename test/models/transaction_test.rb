# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  entry_date  :date
#  sender      :string
#  description :string
#  amount      :decimal(, )
#  currency    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
