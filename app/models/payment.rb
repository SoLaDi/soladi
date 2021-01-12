# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  month          :date
#  amount         :decimal(, )
#  memberships_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Payment < ApplicationRecord
  belongs_to :memberships
end
