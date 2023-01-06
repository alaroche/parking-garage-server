class Garage < ApplicationRecord
  has_and_belongs_to_many :users

  def json
    @json ||= JSON.parse(self.file)
  end

  def redis_conn
    @redis_conn ||= Redis.new
  end

  def num_of_total_spots
    json['parking_levels'].sum { |level| level['parking_spots'].size }
  end

  def spots_on_level(level_id)
    json['parking_levels'][level_id]['parking_spots']
  end

  def num_of_spots_free
    num_of_total_spots - spots_taken.size
  end

  def spots_taken
    redis_conn.keys.map { |k| JSON.parse(k) }
      .select { |k| k['garage_id'].to_i == id }
      .map { |k| k['spot']}
  end

  def free_spots_on_level(level_id)
    spots_on_level(level_id) - spots_taken
  end
end