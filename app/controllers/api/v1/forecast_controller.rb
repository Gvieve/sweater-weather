class Api::V1::ForecastController < ApplicationController

  def index
    location = params[:location]
    data = MapquestService.location(location)[:results].first
    coords = Coordinate.new(data)
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
    forecast = Forecast.new(weather)
    require "pry"; binding.pry
  end
end
