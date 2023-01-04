require 'redis'

desc 'Simulates parking garage data flow'

def first_free_spot(garage)
  free_spot = nil

  garage.file['parking_levels'].each_with_index do |level, i|
    free_spot = garage.free_spots_on_level(i)[0] # TODO: Use level instead of index?

    free_spot ? return free_spot : nil
  end
end

task :valet => :environment do
  data = Redis.new

  while true do
    rand_id = Garage.pluck(:id).sample
    @garage = Garage.find(rand_id)

    if @garage.spots_taken.size < 48
      choice = 'park'
    else
      choice = ['park','leave'][rand(0..2)]
    end

    if choice == 'park'
      print("#{Time.now} - parking\n")
      free_spot = first_free_spot(data, @garage)

      if !!free_spot
        print(free_spot)
        data.set(free_spot.to_json, Time.now)
      else
        print('Lot full\n')
      end
    elsif choice == 'leave'
      print("#{Time.now} - leaving\n")
      unless data.keys.empty?
        session = data.keys[rand(0..data.keys.length-1)]
        session ? data.del(session) : nil
      end
    end

    sleep(2)
  end
end