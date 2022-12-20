# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

obj = {
  name: 'Cherry Tree Plaza Parking',
  address1: '795 Spruce St',
  city: 'Jay',
  state: 'VT',
  zip: '05401',
  parking_levels: [],
}

['A','B','C','D'].each_with_index do |letter, i|
  print("Creating Level #{letter}...\n")
  obj[:parking_levels] << {name: "Level #{letter}"}
  obj[:parking_levels][i]['parking_spots'] = []
  48.times { |spot_idx| obj[:parking_levels][i]['parking_spots'] << spot_idx }
end

# write garage to a json file
File.open("storage/1.json", "w") do |f|
  f.write obj.to_json
end