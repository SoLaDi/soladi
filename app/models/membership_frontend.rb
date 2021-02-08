class MembershipFrontend
  def initialize(membership, total_cost, total_payments)
    @membership = membership
    @total_cost = total_cost
    @total_payments = total_payments
  end

  attr_reader :membership
  attr_reader :total_cost
  attr_reader :total_payments
end