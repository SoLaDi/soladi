class MembershipFrontend
  def initialize(membership, total_cost_since_joined, total_payments)
    @membership = membership
    @total_cost_since_joined = total_cost_since_joined
    @total_payments = total_payments
  end

  attr_reader :membership
  attr_reader :total_cost_since_joined
  attr_reader :total_payments
end