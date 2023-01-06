class UsersController < ApplicationController
  before_action :authenticate_user

  def edit
    render json: user_from_request.to_json
  end

  def update
    @user = user_from_request

    if @user.update!(user_params)
      render status: 200
    else
      render status: 500
    end
  end

  private

  def user_params
    params.permit(:id, :first_name, :last_name, :email)
  end
end