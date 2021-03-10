class HomeController < ApplicationController
  def index
    @data = DashboardData.new(
      calculate_totals,
      calculate_current_year_totals,
      calculate_this_month_totals,
      calculate_last_month_totals,
      calculate_membership_statistics
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
    month_start = Date.new(now.year, now.month)
    month_end = Date.new(now.year, now.month + 1) - 1.day
    payments = Transaction.where(entry_date: month_start..month_end).sum(:amount)
    bids = Bid.where(start_date: ..month_start, end_date: month_end..)
    puts bids.inspect
    cost = bids.inject(0) do |sum, bid|
      sum + bid.total_amount
    end

    Balance.new(cost, payments)
  end

  def calculate_last_month_totals
    last_month = Date.today - 1.month
    month_start = Date.new(last_month.year, last_month.month)
    month_end = Date.new(last_month.year, last_month.month + 1) - 1.day
    payments = Transaction.where(entry_date: month_start..month_end).sum(:amount)

    bids = Bid.where(start_date: ..month_start, end_date: month_end..)
    puts bids.inspect
    cost = bids.inject(0) do |sum, bid|
      sum + bid.total_amount
    end

    Balance.new(cost, payments)
  end

  def calculate_membership_statistics
    today = Date.today
    total = Membership.count
    [].filter
    # current_shares = Membership.where("DATE(startDate) < DATE(?) AND (endDate IS NULL OR DATE(endDate) > DATE(?))", today, today).inject(0) { |sum, membership|
    #   sum + membership.prices.find_by(year: today.year, month: today.month).shares
    # }

    MembershipStatistics.new(total, total, total)
  end
end