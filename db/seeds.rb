# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

garage = Garage.create(
  name: 'Cherry Tree Plaza Parking',
  address1: '795 Spruce St',
  city: 'Jay',
  state: 'VT',
  zip: '05401'
)

['A','B','C','D'].each do |letter|
  print("Creating Level #{letter}...")
  level = ParkingLevel.create(
    garage: garage,
    name: "Level #{letter}"
  )

  48.times {
    ParkingSpot.create(parking_level: level, garage: garage)
  }
end