# == Schema Information
#
# Table name: distribution_points
#
#  id          :integer          not null, primary key
#  name        :string
#  street      :string
#  housenumber :string
#  zipcode     :string
#  city        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#
class DistributionPoint < ApplicationRecord
  has_many :memberships
  belongs_to :person, optional: true

  def total_payments
    memberships.inject(0) do |sum, membership|
      sum + membership.total_payments
    end
  end
end
