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

class DashboardData
  def initialize(total_balance, current_year_balance, this_month_balance, last_month_balance, next_month_balance, membership_stats)
    @total_balance = total_balance
    @current_year_balance = current_year_balance
    @this_month_balance = this_month_balance
    @last_month_balance = last_month_balance
    @next_month_balance = next_month_balance
    @membership_stats = membership_stats
  end

  attr_reader :total_balance
  attr_reader :current_year_balance
  attr_reader :this_month_balance
  attr_reader :last_month_balance
  attr_reader :next_month_balance
  attr_reader :membership_stats
end