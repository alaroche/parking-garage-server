class ParkingSpot < ApplicationRecord
  belongs_to :parking_level
  belongs_to :garage

  def park_in
    update_attribute('taken', true)
  end

  def vacate
    update_attribute('taken', false)
  end
end