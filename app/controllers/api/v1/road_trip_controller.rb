class Api::V1::RoadTripController < ApplicationController

  def create
    user = User.where(api_key: params[:api_key])
    origin = params[:origin]
    destination = params[:destination]

    if !user.empty? && !invalid_location_param(origin, destination)
      route = MapquestService.routes(origin, destination)[:route]
      # require "pry"; binding.pry
      coords = Coordinate.new(route[:boundingBox])
      weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      all_data = {  origin: origin,
                    destination: destination,
                    route: route,
                    weather: weather}
      road_trip = RoadTrip.new(all_data)
      render json: RoadtripSerializer.new(road_trip)
    end
  end

  def invalid_location_param(origin, destination)
      return true if !origin || origin == ""
      return true if !destination || destination == ""
      return true if origin.match(/([^,]+)(, *)([a-z]{2})$/).nil?
      destination.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
