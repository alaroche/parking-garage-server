class GaragesController < ApplicationController
  before_action :authenticate_user, only: [:index]

  def index
    # TODO: Scope to a signed in user.
    garage_info = []
    Garage.all.each do |garage|
      obj = {}
      obj['id'] = garage.id
      obj['place'] = garage.attributes
      obj['total_spots'] = garage.num_of_total_spots
      obj['spots_free'] = garage.num_of_spots_free

      garage_info << obj
    end

    render json: garage_info
  end

  def show
    @garage = Garage.find(params[:id] || 1)

    obj = {}
    obj['place'] = @garage.attributes
    obj['parking_levels'] = []

    @garage.json['parking_levels'].each_with_index do |level,i|
      obj['parking_levels'][i] = {}

      obj['parking_levels'][i]['name'] = level['name']
      obj['parking_levels'][i]['spots_free'] = @garage.free_spots_on_level(i).size
      obj['parking_levels'][i]['total_spots'] = @garage.spots_on_level(i).size
    end

    obj['total_spots'] = @garage.num_of_total_spots
    obj['total_spots_free'] = @garage.num_of_spots_free

    render json: obj
  end

  private

  def garage_params
    params.permit(:id, :name, :address1, :address2, :city, :state, :zip)
  end
end