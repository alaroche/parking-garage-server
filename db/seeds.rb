# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

garage_params = {
  name: 'Cherry Tree Plaza Parking',
  address1: '795 Spruce St',
  city: 'Jay',
  state: 'VT',
  zip: '05401',
}

garage = Garage.create(garage_params)

obj = {garage_id: garage.id, parking_levels: []}
spot_idx = 0
['A','B','C','D'].each_with_index do |letter, i|
  print("Creating Level #{letter}...\n")
  obj[:parking_levels] << {name: "Level #{letter}"}
  obj[:parking_levels][i]['parking_spots'] = []
  48.times do
    obj[:parking_levels][i]['parking_spots'] << spot_idx
    spot_idx += 1
  end
end

# write garage to a json file
File.open("storage/#{garage.id}.json", "w") do |f|
  f.write obj.to_json
end