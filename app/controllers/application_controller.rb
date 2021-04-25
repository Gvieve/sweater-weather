class ApplicationController < ActionController::API

  def render_error(error, status = :bad_request)
    render json: { message: "your request cannot be completed", error: error}, status: status
  end
end
