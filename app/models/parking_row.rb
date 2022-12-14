class ParkingRow < ApplicationRecord
  belongs_to :parking_level
  has_many :parking_spots, dependent: :destroy
end