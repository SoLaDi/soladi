class DashboardData
  def initialize(total_cost, total_payments, current_year_cost, current_year_payments)
    @total_cost = total_cost
    @total_payments = total_payments
    @current_year_cost = current_year_cost
    @current_year_payments = current_year_payments
  end

  attr_reader :total_cost
  attr_reader :total_payments
  attr_reader :current_year_cost
  attr_reader :current_year_payments
end