class ParkingLevel < ApplicationRecord
  belongs_to :garage
  has_many :parking_rows, dependent: :destroy
  has_many :parking_spots
  has_many :parking_sessions

  def num_of_spots_free
    num_of_spots_total - num_of_taken_spots
  end

  def num_of_taken_spots
    parking_sessions.where(stopped_at: nil).count
  end

  def num_of_spots_total
    @num_of_spots_total ||= parking_spots.count
  end

  def to_json
    {
      name: name,
      spots_free: num_of_spots_free,
      spots_total: num_of_spots_total
    }
  end
end