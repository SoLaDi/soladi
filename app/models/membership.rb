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
  accepts_nested_attributes_for :prices

  validates_with MembershipValidator

  # Return a list of date for every month a membership has been active
  # @return [Array<Date>]
  def total_months
    now = Date.today
    endDate = self.endDate && self.endDate < now ? self.endDate : now
    range_to_months(self.startDate, endDate)
  end

  def range_to_months(startDate, endDate)
    (startDate..endDate).uniq { |d| "#{d.month}-#{d.year}" }
  end

  def fiscal_year_to_month_range(year)
    start_date = Date.new(year, 4, 1)
    end_date = Date.new(year + 1, 3, 1)
    range_to_months(start_date, end_date)
  end

  def date_to_fiscal_year(date)
    if date.month > 3
      date.year
    else
      date.year - 1
    end
  end

  def total_cost
    total_months.inject(0) { |sum, date|
      price = self.prices.find_by(year: date.year, month: date.month)
      #TODO: we should handle the case that there is no price set for an existing membership
      if price
        sum + price.total
      else
        sum
      end
    }
  end

  def cost_for_fiscal_year(year)
    fiscal_year_to_month_range(year).inject(0) { |sum, date|
      price = self.prices.find_by(year: date.year, month: date.month)
      if price
        sum + price.total
      else
        sum
      end
    }
  end

  def total_payments_since_joined
    self.payments.all.sum(:amount)
  end

  def payments_for_fiscal_year(year)
    fiscal_year_to_month_range(year).inject(0) { |sum, date|
      payment = self.payments.find_by(year: date.year, month: date.month)
      if payment
        sum + payment.amount
      else
        sum
      end
    }
  end

  def is_trial_membership?
    diff = Date.today - startDate
    diff.to_i < 90
  end
end
