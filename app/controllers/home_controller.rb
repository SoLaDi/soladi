class HomeController < ApplicationController
  def index
    @data = DashboardData.new(
      calculate_totals,
      calculate_current_year_totals,
      calculate_this_month_totals,
      calculate_last_month_totals,
      calculate_next_month_totals,
      calculate_membership_stats,
      calculate_monthly_revenue_graph
    )
  end

  def calculate_monthly_revenue_graph
    start_date = Date.today - 6.months
    end_date = Date.today + 6.months

    revenue = calculate_monthly_payments(start_date, end_date)
    expected = calculate_monthly_costs(start_date, end_date)
    labels = ApplicationHelper.range_to_months(start_date, end_date).map { |month| month.strftime("%b %Y") }

    MonthlyRevenueStats.new(revenue, expected, labels)
  end

  def calculate_monthly_payments(start_date, end_date)
    Transaction.where(entry_date: start_date..end_date).group_by { |transaction|
      Date.new(transaction.entry_date.year, transaction.entry_date.month)
    }.map { |date, transactions|
      [date, transactions.inject(0) { |sum, t| sum + t.amount }]
    }.sort.to_h.values.flatten
  end

  def calculate_monthly_costs(start_date, end_date)
    monthly_buckets = ApplicationHelper.range_to_months(start_date, end_date).map { |month| [month, 0] }.to_h
    puts monthly_buckets
    Bid.all.each do |bid|
      monthly_buckets = monthly_buckets.merge(bid.monthly_amounts) { |key, oldval, newval| oldval + newval }
    end

    monthly_buckets
      .filter { |month, value| month >= start_date && month <= end_date }
      .sort
      .to_h
      .values
      .flatten
  end

  def calculate_totals
    date_range_io_statistics(Date.new(1900, 1), Date.today)
  end

  def calculate_current_year_totals
    now = Date.today
    date_range_io_statistics(Date.new(now.year, 4), Date.new(now.year + 1, 3))
  end

  def calculate_this_month_totals
    now = Date.today
    self.monthly_io_statistics(now)
  end

  def calculate_last_month_totals
    last_month = Date.today - 1.month
    self.monthly_io_statistics(last_month)
  end

  def calculate_next_month_totals
    next_month = Date.today + 1.month
    self.monthly_io_statistics(next_month)
  end

  def monthly_io_statistics(month)

    month_start = Date.new(month.year, month.month)
    month_end = Date.new(month.year, month.month + 1) - 1.day

    date_range_io_statistics(month_start, month_end)
  end

  def date_range_io_statistics(start_date, end_date)
    cost = Bid.total_amount(start_date, end_date)
    payments = Transaction.total_amount(start_date, end_date)

    Balance.new(cost, payments)
  end

  def calculate_membership_stats
    total = Membership.total_count
    active = Membership.active_count
    shares = Bid.total_shares(Date.today)

    MembershipStatistics.new(total, active, shares)
  end
end