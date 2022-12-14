class Garage < ApplicationRecord
  has_many :parking_levels, dependent: :destroy
  has_many :parking_sessions

  def json_template
    obj = {}
    obj['total_spots_free'] = 0
    obj['total_spots'] = 0
    obj['parking_levels'] = []

    parking_levels.includes([:parking_spots, :parking_sessions]).each do |level|
      obj['total_spots_free'] += level.num_of_spots_free
      obj['total_spots'] += level.num_of_spots_total

      obj['parking_levels'] << level.to_json
    end

    obj
  end
end