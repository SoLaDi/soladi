class HomeController < ApplicationController
  def index
    @data = DashboardData.new(
      calculate_totals,
      calculate_current_year_totals,
      calculate_this_month_totals,
      calculate_last_month_totals
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
    payments = Payment.where(year: now.year, month: now.month).sum(:amount)
    cost = Price.where(year: now.year, month: now.month).sum(:amount)

    Balance.new(cost, payments)
  end

  def calculate_last_month_totals
    last_month = Date.today - 1.month
    payments = Payment.where(year: last_month.year, month: last_month.month).sum(:amount)
    cost = Price.where(year: last_month.year, month: last_month.month).sum(:amount)

    Balance.new(cost, payments)
  end
end