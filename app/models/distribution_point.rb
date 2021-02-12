# == Schema Information
#
# Table name: distribution_points
#
#  id           :integer          not null, primary key
#  name         :string
#  street       :string
#  housenumber  :string
#  zipcode      :string
#  city         :string
#  contact_name :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class DistributionPoint < ApplicationRecord
    has_many :memberships
end
