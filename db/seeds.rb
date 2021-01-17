# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts "seeding!"

user = User.create(email: 'test@test.de', password: 'supersicher')

#TODO Membership.create(...) matching data samples in csv file

# Might silently fail otherwise
puts user.errors.inspect