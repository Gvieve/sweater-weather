class Api::V1::UsersController < ApplicationController

  def create
    return invalid_request if !required.all? {|key| params.has_key? key }
    new_user = User.new(user_params)
    if new_user.save
      render json: UsersSerializer.new(new_user), status: :created
    end
  end

  private

  def invalid_request
    error = "Please send a valid request, missing required information"
    render_error(error)
  end

  def required
    [:email, :password, :password_confirmation]
  end

  def user_params
    params[:email] = params[:email].downcase
    params.permit(:email, :password, :password_confirmation)
  end
end
