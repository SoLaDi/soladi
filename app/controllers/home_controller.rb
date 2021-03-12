class HomeController < ApplicationController
  def index
    @data = DashboardData.new(
      calculate_totals,
      calculate_current_year_totals,
      calculate_this_month_totals,
      calculate_last_month_totals,
      calculate_next_month_totals,
      calculate_membership_stats
    )
  end

  def calculate_totals
    payments = 0
    cost = 0
    Membership.all.each do |membership|
      payments += membership.total_payments_since_joined
      cost += membership.total_cost
    end

    Balance.new(cost, payments)
  end

  def calculate_current_year_totals
    payments = 0
    cost = 0
    Membership.all.each do |membership|
      payments += membership.payments_for_fiscal_year(2020)
      cost += membership.cost_for_fiscal_year(2020)
    end

    Balance.new(cost, payments)
  end

  def calculate_this_month_totals
    now = Date.today
    self.monthly_statistics(now)
  end

  def calculate_last_month_totals
    last_month = Date.today - 1.month
    self.monthly_statistics(last_month)
  end

  def calculate_next_month_totals
    next_month = Date.today + 1.month
    self.monthly_statistics(next_month)
  end

  def monthly_statistics(next_month)
    month_start = Date.new(next_month.year, next_month.month)
    month_end = Date.new(next_month.year, next_month.month + 1) - 1.day
    payments = Transaction.where(entry_date: month_start..month_end).sum(:amount)

    bids = Bid.where(start_date: ..month_start, end_date: month_end..)
    puts bids.inspect
    cost = bids.inject(0) do |sum, bid|
      sum + bid.total_amount
    end

    Balance.new(cost, payments)
  end

  def calculate_membership_stats
    today = Date.today
    total = Membership.count
    shares = Bid.all.inject(0) do |sum, bid|
      sum += bid.shares
    end

    [].filter
    # current_shares = Membership.where("DATE(startDate) < DATE(?) AND (endDate IS NULL OR DATE(endDate) > DATE(?))", today, today).inject(0) { |sum, membership|
    #   sum + membership.prices.find_by(year: today.year, month: today.month).shares
    # }

    MembershipStatistics.new(total, total, shares)
  end
end