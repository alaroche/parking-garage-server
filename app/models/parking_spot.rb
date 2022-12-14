class ParkingSpot < ApplicationRecord
  belongs_to :parking_row, dependent: :destroy
  belongs_to :garage
  belongs_to :parking_level

  has_many :parking_sessions
end