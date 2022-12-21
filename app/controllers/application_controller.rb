class ApplicationController < ActionController::API
  def show
    json = JSON.parse(File.read('storage/1.json'))
    r = Redis.new

    obj = {}
    obj['total_spots'] = 0
    obj['total_spots_free'] = 0
    obj['parking_levels'] = []

    json['parking_levels'].each_with_index do |level,i|
      obj['parking_levels'][i] = {}
      obj['parking_levels'][i]['name'] = level['name']

      spots_on_level = json['parking_levels'][i]['parking_spots']

      obj['parking_levels'][i]['spots_free'] = r.keys.any? ? (spots_on_level - r.keys.map { |k| Integer(k) }).size : 0
      obj['parking_levels'][i]['total_spots'] = spots_on_level.size

      # Aggregate garage-level attributes
      obj['total_spots'] += obj['parking_levels'][i]['total_spots']
      obj['total_spots_free'] += obj['parking_levels'][i]['spots_free']
    end

    render json: obj
  end
end