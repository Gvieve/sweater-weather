class Api::V1::UsersController < ApplicationController

  def create
    return render_invalid_params if !required.all? {|key| params.has_key? key }
    new_user = User.create!(user_params)
    render json: UsersSerializer.new(new_user), status: :created
  end

  private

  def required
    [:email, :password, :password_confirmation]
  end

  def user_params
    params[:email] = params[:email].downcase
    params.permit(:email, :password, :password_confirmation)
  end
end
