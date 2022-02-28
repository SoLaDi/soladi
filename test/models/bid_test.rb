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
#  person_id       :integer
#
require 'test_helper'

class BidTest < ActiveSupport::TestCase
  test "active_between gets bids for fiscal_year" do
    start_date = Date.new(2020, 4, 1)
    end_date = Date.new(2021, 3, 31)
    result = Bid.active_between(start_date, end_date)
    result.each do |r|
      puts r.id
      puts r.start_date
      puts r.end_date
    end
    assert result.map { |r| r.id } == [3, 4]
  end

  test "active_at gets a bid" do
    date = Date.new(2020, 5, 10)
    result = Bid.active_at(date)
    result.each do |r|
      puts r.id
      puts r.start_date
      puts r.end_date
    end
    assert result.map { |r| r.id } == [4]
  end

  test "active_at gets single month bid" do
    date = Date.new(2020, 4, 10)
    result = Bid.active_at(date)
    result.each do |r|
      puts r.id
      puts r.start_date
      puts r.end_date
    end
    assert result.map { |r| r.id } == [3]
  end
end
