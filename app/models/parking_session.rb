class ParkingSession < ApplicationRecord
  belongs_to :parking_spot, dependent: :destroy
end