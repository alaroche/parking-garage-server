class GaragesController < ActionController::API
  def show
    @garage = Garage.find(params[:id] || 1)

    render json: @garage.live_data
  end

  def profile
    @garage = Garage.find(params[:id] || 1)
    @garage = @garage.attributes.except('created_at','updated_at')

    render json: @garage.to_json
  end

  def update
    @garage = Garage.find(params[:id])
    @garage.update!(garage_params)

    if @garage.save
      render status: 200
    else
      render status: 500
    end
  end

  private

  def garage_params
    params.permit(:id, :name, :address1, :address2, :city, :state, :zip)
  end
end