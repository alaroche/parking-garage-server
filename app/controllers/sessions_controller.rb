class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])

    if !!@user && @user.authenticate(params[:password])
      current_time = Time.now
      session[:user_id] = @user.id
      token = JWT.encode({user_id: @user.id, signed_in_at: current_time}, Rails.application.secret_key_base, 'HS256')
      @user.update_attribute(:signed_in_at, current_time)

      render json: {jwt: token}
    else
      render status: 401
    end
  end
end