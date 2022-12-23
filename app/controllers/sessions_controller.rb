class SessionsController < ActionController::API
  def create
    @user = User.find_by(username: params[:username])

    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      token = JWT.encode({user_id: @user.id}, Rails.application.secret_key_base, 'HS256')

      render json: {json_web_token: token}
    else
      render status: 401
    end
  end

  def destroy
    session[:user_id] = nil

    render status: 200
  end
end