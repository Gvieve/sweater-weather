class Api::V1::ForecastController < ApplicationController

  def index
    location = params[:location]
    data = MapquestService.location(location)[:results].first
    coords = Coordinate.new(data)
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
  end
end
