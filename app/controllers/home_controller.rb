class HomeController < ApplicationController
  def index
    total_payments, total_cost = calculate_totals
    current_year_payments, current_year_cost = calculate_current_year_totals
    @data = DashboardData.new(total_cost, total_payments, current_year_cost, current_year_payments)
  end

  def calculate_totals
    total_payments = 0
    total_cost = 0
    Membership.all.each do |membership|
      total_payments += membership.total_payments_since_joined
      total_cost += membership.total_cost
    end

    [total_payments, total_cost]
  end

  def calculate_current_year_totals
    payments = 0
    cost = 0
    Membership.all.each do |membership|
      payments += membership.payments_for_fiscal_year(2020)
      cost += membership.cost_for_fiscal_year(2020)
    end

    [payments, cost]
  end
end