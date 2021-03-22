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
  def initialize(revenue, expected, labels)
    @revenue = revenue
    @expected = expected
    @labels = labels
  end

  attr_accessor :revenue
  attr_accessor :expected
  attr_accessor :labels
end

class DashboardData
  def initialize(total_balance, current_year_balance, this_month_balance, last_month_balance, next_month_balance, membership_stats, monthly_revenue)
    @total_balance = total_balance
    @current_year_balance = current_year_balance
    @this_month_balance = this_month_balance
    @last_month_balance = last_month_balance
    @next_month_balance = next_month_balance
    @membership_stats = membership_stats
    @monthly_revenue = monthly_revenue
  end

  attr_reader :total_balance
  attr_reader :current_year_balance
  attr_reader :this_month_balance
  attr_reader :last_month_balance
  attr_reader :next_month_balance
  attr_reader :membership_stats
  attr_reader :monthly_revenue
end