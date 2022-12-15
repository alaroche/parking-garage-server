class ParkingLevel < ApplicationRecord
  belongs_to :garage
  has_many :parking_spots, dependent: :destroy

  def num_of_spots_free
    num_of_spots_total - num_of_taken_spots
  end

  def num_of_taken_spots
    parking_spots.where(taken: true).count
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