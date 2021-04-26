class Api::V1::ForecastController < ApplicationController

  def index
    forecast = ForecastFacade.get_forecast(params)
    return invalid_location if forecast.nil?
    render json: ForecastSerializer.new(forecast)
  end

  private

  def invalid_location
    error = "Please include a valid location"
    render_error(error)
  end
end
