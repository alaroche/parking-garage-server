class GaragesController < ActionController::API
  def index
    # TODO: Scope to a signed in user.
    garage_info = []
    Garage.all.each do |garage|
      obj = {}
      obj['id'] = garage.id
      obj['name'] = garage.name
      obj['total_spots'] = garage.num_of_total_spots
      obj['total_spots_free'] = garage.num_of_spots_free

      garage_info << obj
    end

    render json: garage_info
  end

  def show
    @garage = Garage.find(params[:id] || 1)

    obj = @garage.attributes
    obj['total_spots'] = 0
    obj['total_spots_free'] = 0
    obj['parking_levels'] = []

    @garage.file['parking_levels'].each_with_index do |level,i|
      obj['parking_levels'][i] = {}

      obj['parking_levels'][i]['name'] = level['name']
      obj['parking_levels'][i]['spots_free'] = @garage.free_spots_on_level(i).size
      obj['parking_levels'][i]['total_spots'] = @garage.spots_on_level(i).size

      # Aggregate garage-level attributes
      obj['total_spots'] += obj['parking_levels'][i]['total_spots']
      obj['total_spots_free'] += obj['parking_levels'][i]['spots_free']
    end

    render json: obj
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