require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

city = Faker::Address.city
state = Faker::Address.state_abbr
zip = Faker::Address.zip

10.times do
  garage_address = {
    name: Faker::Address.community,
    address1: Faker::Address.street_address,
    city: city,
    state: state,
    zip: zip
  }

  print("Creating #{garage_address[:name]}")
  @garage = Garage.create(garage_address)

  obj = {parking_levels: []}
  spot_idx = 0
  spots_per_level = [24,36,48][rand(0..2)]
  ['A','B','C','D','E'][0..rand(1..4)].each_with_index do |letter, i|
    print("Creating Level #{letter}...\n")
    obj[:parking_levels] << {name: "Level #{letter}"}
    obj[:parking_levels][i]['parking_spots'] = []
    spots_per_level.times do
      obj[:parking_levels][i]['parking_spots'] << spot_idx
      spot_idx += 1
    end
  end

  @garage.update_attribute(:file, obj.to_json)
end

# For test purposes only.
User.create!(username: 'admin', password: 'admin')