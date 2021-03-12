# == Schema Information
#
# Table name: people
#
#  id            :integer          not null, primary key
#  name          :string
#  surname       :string
#  email         :string
#  phone         :string
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Person < ApplicationRecord
  belongs_to :membership
  has_one :distribution_point

  def full_name
    "#{name} #{surname}"
  end
end
