require 'date'

# == Schema Information
#
# Table name: memberships
#
#  id                :integer          not null, primary key
#  shares            :integer
#  startDate         :date
#  endDate           :date
#  distributionPoint :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Membership < ApplicationRecord
    has_many :transactions
    has_many :payments

    def is_trial_membership?
        diff = endDate - startDate
        diff.to_i < 90
    end
end