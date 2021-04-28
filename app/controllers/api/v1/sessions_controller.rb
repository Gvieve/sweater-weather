class Api::V1::SessionsController < ApplicationController
  def create
    user = SessionsFacade.authenticate_user(params)
    if user == 'invalid'
      render_invalid_params
    elsif user
      render json: UsersSerializer.new(user), status: :created
    else
      render_error("The email or password you entered is incorrect")
    end
  end
end
