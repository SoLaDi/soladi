require 'date'

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
class Membership < ApplicationRecord
  has_many :transactions
  has_many :payments
  has_many :prices
  belongs_to :distribution_point

  validates_with MembershipValidator

  # Return a list of date for every month a membership has been active
  # @return [Array<Date>]
  def total_months
    now = Date.today
    endDate = self.endDate && self.endDate < now ? self.endDate : now
    (self.startDate..endDate).uniq { |d| "#{d.month}-#{d.year}" }
  end

  def total_cost
    cost = total_months.inject(0) { |sum, date|
      price = self.prices.find_by(year: date.year, month: date.month)
      #TODO: we should handle the case that there is no price set for an existing membership
      if price
        sum + price.total
      else
        sum
      end
    }
    puts "COSTTTTTTTTTT"
    puts cost
    cost
  end

  def total_payments_since_joined
    payments = self.payments.all.sum(:amount)
    payments
  end

  def is_trial_membership?

    diff = Date.today - startDate
    diff.to_i < 90
  end
end
