# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts "seeding!"
require "time"

puts "Creating test@test.de user"
user = User.create(email: 'test@test.de', password: 'supersicher')
# Might silently fail otherwise
puts user.errors.inspect

puts "Creating 10 memberships"
10.times do |i|
  #  id            :integer          not null, primary key
  #  year          :integer
  #  amount        :decimal(, )
  #  membership_id :integer          not null

  membership_id = 1000 + i
  m = Membership.create(id: membership_id, shares: 2, startDate: Date.new(2021, 1, 8), endDate: Date.new(2022, 1, 8), distributionPoint: "Berlin")
  unless m
    puts m.errors.inspect
  end

  p = Price.create(year: 2021, amount: 95.5 + i, membership_id: membership_id)
  unless p
    puts p.errors.inspect
  end
end
