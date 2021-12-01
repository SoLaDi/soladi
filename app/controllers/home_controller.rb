class HomeController < ApplicationController
  def index
    @data = DashboardData.new(
      calculate_totals,
      calculate_current_year_totals,
      calculate_balance_triple,
      calculate_membership_stats,
      calculate_monthly_revenue_graph,
      calculate_monthly_shares
    )
  end

  def calculate_monthly_revenue_graph
    start_date = Date.today - 6.months
    end_date = Date.today + 6.months

    revenue = calculate_monthly_payments(start_date, end_date)
    not_associated_payments = calculate_monthly_not_associated_payments(start_date, end_date)
    expected = calculate_monthly_costs(start_date, end_date)
    labels = ApplicationHelper.range_to_months(start_date, end_date).map { |month| month.strftime("%b %Y") }

    MonthlyRevenueStats.new(revenue, not_associated_payments, expected, labels)
  end

  def transaction_grouping_date(date)
    if date.day >= 15
      Date.new(date.year, date.month) + 1.month
    else
      Date.new(date.year, date.month)
    end
  end

  def calculate_monthly_payments(start_date, end_date)
    monthly_buckets = ApplicationHelper.range_to_months(start_date, end_date).map { |month| [month, 0] }.to_h
    Transaction
      .associated_with_membership
      .where(entry_date: start_date..end_date)
      .group_by { |transaction|
        transaction_grouping_date(transaction.entry_date)
      }.each { |date, transactions|
      monthly_buckets[date] = transactions.inject(0) { |sum, t| sum + t.amount }
    }

    monthly_buckets
      .sort
      .to_h
      .values
  end

  def calculate_monthly_not_associated_payments(start_date, end_date)
    monthly_buckets = ApplicationHelper.range_to_months(start_date, end_date).map { |month| [month, 0] }.to_h
    Transaction
      .not_associated
      .where(entry_date: start_date..end_date)
      .group_by { |transaction|
        transaction_grouping_date(transaction.entry_date)
      }.each { |date, transactions|
      monthly_buckets[date] = transactions.inject(0) { |sum, t| sum + t.amount }
    }

    monthly_buckets
      .sort
      .to_h
      .values
  end

  def calculate_monthly_costs(start_date, end_date)
    monthly_buckets = ApplicationHelper.range_to_months(start_date, end_date).map { |month| [month, 0] }.to_h
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

  def calculate_monthly_shares
    start_date = Date.today - 6.months
    end_date = Date.today + 6.months
    months = ApplicationHelper.range_to_months(start_date, end_date)
    labels = months.map { |month| month.strftime("%b %Y") }
    shares = months.map { |month| Bid.total_shares(month) }

    MonthlyShares.new(shares, labels)
  end

  def calculate_totals
    date_range_revenue_statistics(Date.new(1900, 1), Date.today)
  end

  def calculate_current_year_totals
    now = Date.today
    date_range_revenue_statistics(Date.new(now.year, 4), Date.new(now.year + 1, 3))
  end

  def calculate_balance_triple
    now = Date.today
    this_month = Date.new(now.year, now.month, 1)
    last_month = this_month - 1.month
    next_month = this_month + 1.month
    last_month_balance = self.monthly_revenue_statistics(last_month)
    this_month_balance = self.monthly_revenue_statistics(this_month)
    next_month_balance = self.monthly_revenue_statistics(next_month)

    BalanceTriple.new(last_month_balance, this_month_balance, next_month_balance)
  end

  # @param month - a Date for which year-month the calculation is done
  def monthly_revenue_statistics(month)
    last_month = month - 1.month

    month_start = Date.new(month.year, last_month.month, 15)
    month_end = Date.new(month.year, month.month, 14)

    cost = Bid.total_amount(month, month)
    payments = Transaction.total_amount(month_start, month_end)

    Balance.new(month_start, month_end, cost, payments)
  end

  def date_range_revenue_statistics(start_date, end_date)
    cost = Bid.total_amount(start_date, end_date)
    payments = Transaction.total_amount(start_date, end_date)

    Balance.new(start_date, end_date, cost, payments)
  end

  def calculate_membership_stats
    total = Membership.total_count
    active = Membership.active_count
    shares = Bid.total_shares(Date.today)

    MembershipStatistics.new(total, active, shares)
  end
end