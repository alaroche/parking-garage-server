class ApplicationController < ActionController::API
  before_action :validate_header, only: [:user_from_request]

  USER_SESSION_TTL = 7.days
  HTTP_UNAUTHORIZED = 401

  def decoded_jwt_from_request
    jwt = request.headers['Authorization'].split(' ').last
    JWT.decode(jwt, nil, false)[0]
  end

  def user_from_request
    User.find_by_id(decoded_jwt_from_request['user_id'])
  end

  def authenticate_user
    @user = user_from_request

    unless !!@user &&
      @user.signed_in_at + USER_SESSION_TTL > Time.now &&
      Time.parse(@user.signed_in_at.to_s) == Time.parse(decoded_jwt_from_request['signed_in_at'])

      render status: HTTP_UNAUTHORIZED
    end
  end

  private

  def validate_header
    if request.headers['Authorization'].nil?
      render status: HTTP_UNAUTHORIZED
      return
    end
  end
end