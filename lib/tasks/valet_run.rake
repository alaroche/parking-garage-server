require 'redis'

desc 'Simulates parking garage data flow'

def first_free_spot(garage)
  free_spot = nil

  garage.json['parking_levels'].each_with_index do |level, i|
    free_spot = garage.free_spots_on_level(i)[0] # TODO: Use level instead of index?

    return free_spot if free_spot
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
      free_spot = first_free_spot(@garage)

      if !!free_spot
        print("#{Time.now} - #{@garage.name} parking in spot ##{free_spot}\n")
        data.set({garage_id: @garage.id, spot: free_spot}.to_json, Time.now)
      else
        print("#{Time.now} - #{@garage.name} lot full.\n")
      end
    elsif choice == 'leave'
      unless data.keys.empty?
        session = data.keys[rand(0..data.keys.length-1)]
        print("#{Time.now} - #{@garage.name} leaving spot.\n")
        session ? data.del(session) : nil
      end
    end

    sleep(1)
  end
end