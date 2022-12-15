desc 'Simulates parking garage data flow'

task :valet => :environment do
  while true do
    choice = ['park','leave','relax'][rand(0..2)]

    if choice == 'park'
      print("#{Time.now} - parking\n")
      ParkingSpot.where(taken: false).first.park_in
    elsif choice == 'leave'
      print("#{Time.now} - leaving\n")
      spot = ParkingSpot.where(taken: true).first
      spot ? spot.vacate : nil
    else
      print("#{Time.now} - relaxing\n")
    end

    sleep(2)
  end
end