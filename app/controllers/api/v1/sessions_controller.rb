class Api::V1::SessionsController < ApplicationController
  def create
    return render_invalid_params if !required.all? {|key| params.has_key? key }
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      render json: UsersSerializer.new(user), status: :created
    else
      error = "The email or password you entered is incorrect"
      render_error(error)
    end
  end

  private

  def required
    [:email, :password]
  end
end
