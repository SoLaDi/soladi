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
10.times do |i|
  membership_id = 1000 + i
  ms = Membership.create(id: membership_id, startDate: Date.new(2020, 1, 8), endDate: nil, distribution_point_id: dp_mahlsdorf.id)
  unless ms
    puts ms.errors.inspect
  end

  (1..12).each do |m|
    p = Price.create(year: 2020, month: m, shares: 1, amount: 10, membership_id: membership_id)
    unless p
      puts p.errors.inspect
    end
  end

  (1..12).each do |m|
    p = Price.create(year: 2021, month: m, shares: 1, amount: 20, membership_id: membership_id)
    unless p
      puts p.errors.inspect
    end
  end
end
