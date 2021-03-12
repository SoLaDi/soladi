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
require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
