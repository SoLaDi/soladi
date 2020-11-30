require 'date'

# == Schema Information
#
# Table name: memberships
#
#  id                :integer          not null, primary key
#  shares            :integer
#  startDate         :datetime
#  endDate           :datetime
#  distributionPoint :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Membership < ApplicationRecord
    def is_trial_membership?
        diff = endDate - startDate
        diff.to_i < 90
    end
end
