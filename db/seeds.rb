# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts "seeding!"
require "time"

puts "Creating test@test.de user"
user = User.create(email: 'test@test.de', password: 'supersicher')
# Might silently fail otherwise
unless user
  puts user.errors.inspect
end

dp_mahlsdorf = DistributionPoint.create(name: "Mahlsdorf Süd", street: "Musterstraße", housenumber: "123", zipcode: "12345", city: "Berlin")
dp_treptow = DistributionPoint.create(name: "Treptow", street: "Teststraße", housenumber: "234", zipcode: "23456", city: "Berlin")

puts "Creating 10 memberships"
5.times do |i|
  membership_id = 1000 + i
  puts membership_id
  ms = Membership.new(id: membership_id, startDate: Date.new(2020, 5, 8), endDate: nil, distribution_point_id: dp_mahlsdorf.id)
  ms.bids.build(start_date: Date.new(2020, 4, 1), end_date: Date.new(2021, 3, 1), shares: 1, amount: 10)
  ms.save
  unless ms
    puts ms.errors.inspect
  end
end

5.times do |i|
  membership_id = 1100 + i
  puts membership_id
  ms = Membership.new(id: membership_id, startDate: Date.new(2020, 5, 8), endDate: nil, distribution_point_id: dp_treptow.id)
  ms.bids.build(start_date: Date.new(2020, 4, 1), end_date: Date.new(2021, 3, 1), shares: 2, amount: 20.1)
  ms.save
  unless ms
    puts ms.errors.inspect
  end
end
