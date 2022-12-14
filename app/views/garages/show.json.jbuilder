json.total_spots_free @garage.num_of_spots_free
json.total_spots @garage.num_of_spots_total

json.array! @garage.parking_levels do |level|
  json.name level.name
  json.spots_free level.num_of_spots_free
  json.spots_total level.num_of_spots_total
end