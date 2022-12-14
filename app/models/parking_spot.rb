class ParkingSpot < ApplicationRecord
  belongs_to :parking_level
  belongs_to :garage

  has_many :parking_sessions
end