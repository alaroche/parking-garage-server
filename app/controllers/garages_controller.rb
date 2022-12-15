class GaragesController < ActionController::API
  def show
    @garage = Garage.last

    render json: @garage.json_template
  end
end