class Balance
  def initialize(cost, payments)
    @cost = cost
    @payments = payments
  end

  attr_accessor :cost
  attr_accessor :payments
end

class DashboardData
  def initialize(total_balance, current_year_balance, this_month_balance, last_month_balance)
    @total_balance = total_balance
    @current_year_balance = current_year_balance
    @this_month_balance = this_month_balance
    @last_month_balance = last_month_balance
  end

  attr_reader :total_balance
  attr_reader :current_year_balance
  attr_reader :this_month_balance
  attr_reader :last_month_balance
end