class Api::V1::ForecastController < ApplicationController

  def index
    return invalid_location if !location || location == ""
    data = MapquestService.location(location)[:results].first
    coords = Coordinate.new(data)
    return invalid_location if default(coords)
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
    render json: ForecastSerializer.new(Forecast.new(weather))
  end

  private

  def invalid_location
    error = "Please include a valid location"
    render_error(error)
  end

  def default(coords)
    coords.latitude == 39.390897 && coords.longitude == -99.066067
  end

  def location
    params[:location]
  end
end
