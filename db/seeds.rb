# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
merchant_1 = Merchant.first
bulk1 = merchant_1.bulk_discounts.create!(percent: 10, threshold: 10)
bulk2 = merchant_1.bulk_discounts.create!(percent: 15, threshold: 13)
bulk3 = merchant_1.bulk_discounts.create!(percent: 20, threshold: 110)
