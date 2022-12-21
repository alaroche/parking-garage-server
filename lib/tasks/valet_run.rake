require 'redis'

desc 'Simulates parking garage data flow'

def first_free_spot(redis_conn)
  garage = JSON.parse(File.read('storage/1.json'))
  free_spot = nil

  garage['parking_levels'].each_with_index do |level, i|
    spots_on_level = garage['parking_levels'][i]['parking_spots']
    spots_taken = spots_on_level & redis_conn.keys.map { |k| Integer(k) }

    free_spot = (spots_on_level - spots_taken)[0]

    if free_spot
      print("Checking level #{i}")
      return free_spot
    elsif garage['parking_levels'].size === i + 1
      nil
    end
  end
end

task :valet => :environment do
  data = Redis.new

  while true do
    if data.keys.size < 48
      choice = 'park'
    else
      choice = ['park','leave','relax'][rand(0..2)]
    end

    if choice == 'park'
      print("#{Time.now} - parking\n")
      free_spot = first_free_spot(data)

      if !!free_spot
        data.set(free_spot, Time.now)
      else
        print('Lot full')
      end
    elsif choice == 'leave'
      print("#{Time.now} - leaving\n")
      unless data.keys.empty?
        session = data.keys[rand(0..data.keys.length-1)]
        session ? data.del(session) : nil
      end
    else
      print("#{Time.now} - relaxing\n")
    end

    sleep(2)
  end
end