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
  has_many :bids
  has_many :people
  belongs_to :distribution_point
  accepts_nested_attributes_for :bids

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

      if Membership.exists?(membership_id)
        duplicate_rows.push row
      else
        membership = Membership.new(id: membership_id, startDate: Date.new(2021, 4), distribution_point_id: distribution_point_id)
        if membership.save
          imported_rows.push row
        else
          puts "############ BROKEN TRANSACTION BELOW ############"
          puts membership.inspect
          puts membership.errors.full_messages
          invalid_rows.push row
        end
      end
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
    today = Date.today
    self.bids.all.inject(0) do |total_sum, bid|
      total_sum + bid.expand_to_months.inject(0) do |bid_sum, bid_month|
        if bid_month < today
          bid_sum + bid.monthly_amount
        else
          bid_sum
        end
      end
    end
  end

  def cost_for_fiscal_year(year)
    self.bids.where(start_date: Date.new(year, 4)).inject(0) do |sum, bid|
      sum + bid.monthly_amount
    end
  end

  def total_payments_since_joined
    self.transactions.all.sum(:amount)
  end

  def payments_for_fiscal_year(year)
    self.transactions.where(entry_date: Date.new(year, 4)..Date.new(year + 1, 3)).sum(:amount)
  end

  def is_trial_membership?
    diff = Date.today - startDate
    diff.to_i < 90
  end
end
