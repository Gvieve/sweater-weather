class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

  def render_error(error, status = :bad_request)
    render json: { message: "your request cannot be completed", error: error}, status: status
  end

  def render_invalid_record(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_invalid_params
    error = "Invalid request, please include valid parameters"
    render json: { message: "your request cannot be completed", error: error}, status: :bad_request
  end
end
