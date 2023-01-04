require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

5.times do
  garage_params = {
    name: Faker::Address.community,
    address1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip,
  }

  garage = Garage.create(garage_params)
  print("Creating #{garage.name}")

  obj = {garage_id: garage.id, parking_levels: []}
  spot_idx = 0
  ['A','B','C','D','E'][0..rand(1..4)].each_with_index do |letter, i|
    print("Creating Level #{letter}...\n")
    obj[:parking_levels] << {name: "Level #{letter}"}
    obj[:parking_levels][i]['parking_spots'] = []
    [24,36,48][rand(0..2)].times do
      obj[:parking_levels][i]['parking_spots'] << spot_idx
      spot_idx += 1
    end
  end

  # write garage to a json file
  File.open("storage/#{garage.id}.json", "w") do |f|
    f.write obj.to_json
  end
end