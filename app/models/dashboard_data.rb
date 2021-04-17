class Balance
  def initialize(cost, payments)
    @cost = cost
    @payments = payments
  end

  attr_accessor :cost
  attr_accessor :payments
end

class MembershipStatistics
  def initialize(total_amount, currently_active, current_shares)
    @total_amount = total_amount
    @currently_active = currently_active
    @current_shares = current_shares
  end

  attr_reader :total_amount
  attr_reader :currently_active
  attr_reader :current_shares
end

class MonthlyRevenueStats
  def initialize(revenue, not_associated_payments, expected, labels)
    @revenue = revenue
    @not_associated_payments = not_associated_payments
    @expected = expected
    @labels = labels
  end

  attr_accessor :revenue
  attr_accessor :not_associated_payments
  attr_accessor :expected
  attr_accessor :labels
end

class MonthlyShares
  def initialize(shares, labels)
    @shares = shares
    @labels = labels
  end

  attr_accessor :shares
  attr_accessor :labels
end

class DashboardData
  def initialize(total_balance, current_year_balance, this_month_balance, last_month_balance, next_month_balance, membership_stats, monthly_revenue, monthly_shares)
    @total_balance = total_balance
    @current_year_balance = current_year_balance
    @this_month_balance = this_month_balance
    @last_month_balance = last_month_balance
    @next_month_balance = next_month_balance
    @membership_stats = membership_stats
    @monthly_revenue = monthly_revenue
    @monthly_shares = monthly_shares
  end

  attr_reader :total_balance
  attr_reader :current_year_balance
  attr_reader :this_month_balance
  attr_reader :last_month_balance
  attr_reader :next_month_balance
  attr_reader :membership_stats
  attr_reader :monthly_revenue
  attr_reader :monthly_shares
end