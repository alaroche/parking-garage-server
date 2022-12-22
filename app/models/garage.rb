class Garage < ApplicationRecord
  has_and_belongs_to_many :users

  def live_data
    json = JSON.parse(File.read("storage/#{id}.json"))

    obj = Garage.first.attributes
    obj['total_spots'] = 0
    obj['total_spots_free'] = 0
    obj['parking_levels'] = []

    redis_conn = Redis.new
    json['parking_levels'].each_with_index do |level,i|
      obj['parking_levels'][i] = {}
      spots_on_level = json['parking_levels'][i]['parking_spots']

      obj['parking_levels'][i]['name'] = level['name']
      obj['parking_levels'][i]['spots_free'] = redis_conn.keys.any? ? (spots_on_level - redis_conn.keys.map { |k| Integer(k) }).size : 0
      obj['parking_levels'][i]['total_spots'] = spots_on_level.size

      # Aggregate garage-level attributes
      obj['total_spots'] += obj['parking_levels'][i]['total_spots']
      obj['total_spots_free'] += obj['parking_levels'][i]['spots_free']
    end

    obj
  end
end