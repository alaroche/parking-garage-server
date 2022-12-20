class Garage < ApplicationRecord
  has_many :users
  has_many :parking_levels, dependent: :destroy
  has_many :parking_spots

  # {
  #  total_spots_free: 0,
  #  total_spots: 193,
  #  parking_levels: [
  #    name: '',
  #    spots_taken: 0,
  #    total_spots: 48
  #  ]
  # }

  def json_template
    json = JSON.parse(File.read('storage/garage.json'))
    r = Redis.new

    obj = {}
    obj['total_spots'] = json['parking_spots'].size
    obj['total_spots_free'] = obj['total_spots'] - r.keys.size
    obj['parking_levels'] = []

    json['parking_levels'].each_with_index do |level,i|
      obj['parking_levels'][i] = {}
      spots_on_level = json['parking_spots'].select { |spot| spot['parking_level_id'] == level['id'] }
      obj['parking_levels'][i]['name'] = level['name']
      obj['parking_levels'][i]['spots_taken'] = (spots_on_level.map { |s| s['id'] } & r.keys.map { |k| Integer(k) }).size
      obj['parking_levels'][i]['total_spots'] = spots_on_level.size
    end

    obj
  end
end

