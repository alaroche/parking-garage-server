class GaragesController < ActionController::API

  def show
    @garage = Garage.find(1)

    render json: @garage.json_template
  end
end