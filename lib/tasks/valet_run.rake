require 'redis'

desc 'Simulates parking garage data flow'

def first_free_spot(redis_conn)
  num_of_spots = JSON.parse(File.read('storage/garage.json'))['parking_spots'].size

  binary = Array.new(num_of_spots, 0)

  taken_spots = redis_conn.keys
  taken_spots.each_with_index do |spot, i|
    binary[i] = 1
  end

  binary.find_index(0)
end

task :valet => :environment do
  while true do
    #choice = 'park'
    choice = ['park','leave','relax'][rand(0..2)]

    data = Redis.new

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