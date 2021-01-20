# == Schema Information
#
# Table name: prices
#
#  id            :integer          not null, primary key
#  month         :integer
#  year          :integer
#  shares        :integer
#  amount        :decimal(, )
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Price < ApplicationRecord
  belongs_to :membership

  def total
    self.amount * self.shares
  end
end
