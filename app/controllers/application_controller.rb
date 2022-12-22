class ApplicationController < ActionController::API
  def show
    garage = Garage.find(params[:id] || 1)

    render json: garage.live_data
  end
end