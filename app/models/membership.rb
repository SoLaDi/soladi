require 'date'

# == Schema Information
#
# Table name: memberships
#
#  id                :integer          not null, primary key
#  startDate         :date
#  endDate           :date
#  distributionPoint :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Membership < ApplicationRecord
  has_many :transactions
  has_many :payments
  has_many :prices

  # @return [Array<Date>]
  def months_since_joined
    (self.startDate..Date.today).uniq { |d| "#{d.month}-#{d.year}" }
  end

  def total_cost_since_joined
    months_since_joined.inject(0) { |sum, date|
      price = self.prices.find_by(year: date.year, month: date.month)
      #TODO: we should handle the case that there is no price set for an existing membership
      if price
        sum + price.total
      else
        sum
      end
    }
  end

  def is_trial_membership?
    diff = endDate - startDate
    diff.to_i < 90
  end
end
