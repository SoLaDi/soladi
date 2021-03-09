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
  has_many :people
  belongs_to :distribution_point
  accepts_nested_attributes_for :prices

  validates_with MembershipValidator

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    # CSV columns: membership_id, distribution_point_id
    CSV.foreach(file.path, "r", headers: true, col_sep: ",", encoding: "utf-8") do |row|
      total_rows_count += 1

      membership_id = row["membership_id"]
      distribution_point_id = row["distribution_point_id"]

      Membership.create(id: membership_id, startDate: Date.today, distribution_point_id: distribution_point_id)
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "ignored rows: #{ignored_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"

    ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)
  end

  # Return a list of date for every month a membership has been active
  # @return [Array<Date>]
  def total_months
    now = Date.today
    end_date = self.endDate && self.endDate < now ? self.endDate : now
    range_to_months(self.startDate, end_date)
  end

  def range_to_months(start_date, end_date)
    (start_date..end_date).uniq { |d| "#{d.month}-#{d.year}" }
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
