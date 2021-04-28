class Api::V1::UsersController < ApplicationController

  def create
    new_user = UsersFacade.create_user(params)
    return render_invalid_params if new_user.nil?
    render json: UsersSerializer.new(new_user), status: :created
  end
end
