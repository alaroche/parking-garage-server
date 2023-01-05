class Garage < ApplicationRecord
  has_and_belongs_to_many :users

  # TODO: Check this for veracity
  def json
    @json ||= JSON.parse(self.file)
  end

  def attributes
    json['place']
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
      .select { |k| k['garage_id'] == id }
      .map { |k| k['spot']}
  end

  def free_spots_on_level(level_id)
    spots_on_level(level_id) - spots_taken
  end

  def spots_free_on_level(level_id)
    redis_conn.keys.any? ? (spots_on_level(level_id) - redis_conn.keys.map { |k| k['spot'] }).size : 0
  end
end