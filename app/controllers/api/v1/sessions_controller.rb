class Api::V1::SessionsController < ApplicationController
  def create
    return invalid_request if !required.all? {|key| params.has_key? key }
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      render json: UsersSerializer.new(user), status: :created
    else
      error = "The email or password you entered is incorrect"
      render_error(error)
    end
  end

  private

  def invalid_request
    error = "Please send a valid request, missing required information"
    render_error(error)
  end

  def required
    [:email, :password]
  end
end
