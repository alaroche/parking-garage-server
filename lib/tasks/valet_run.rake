require 'redis'

desc 'Simulates parking garage data flow'

def first_free_spot(redis_conn)
  garage = JSON.parse(File.read('storage/1.json'))
  free_spot = nil

  garage['parking_levels'].each_with_index do |level, i|
    num_of_spots = garage['parking_levels'][i]['parking_spots'].size

    binary = Array.new(num_of_spots, 0)

    taken_spots = redis_conn.keys
    taken_spots.each_with_index do |spot, i|
      binary[i] = 1
    end

    free_spot = binary.find_index(0)
    free_spot ? break : nil
  end

  free_spot
end

task :valet => :environment do
  while true do
    data = Redis.new

    if data.keys.size < 48
      choice = 'park'
    else
      choice = ['park','leave','relax'][rand(0..2)]
    end

    if choice == 'park'
      print("#{Time.now} - parking\n")
      free_spot = first_free_spot(data)

      !!free_spot ? data.set(first_free_spot(data), Time.now) : print('Lot full')
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