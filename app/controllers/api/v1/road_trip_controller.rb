class Api::V1::RoadTripController < ApplicationController

  def create
    user = User.where(api_key: params[:api_key])
    origin = params[:origin]
    destination = params[:destination]

    if !user.empty? && !invalid_location_param(origin, destination)
      route = MapquestService.routes(origin, destination)[:route]
      if route[:routeError][:errorCode] == 2
        all_data = {  origin: origin,
                      destination: destination,
                      route: nil,
                      weather: nil}
        road_trip = RoadTrip.new(all_data)
        render json: RoadtripSerializer.new(road_trip)
      else
        coords = Coordinate.new(route[:boundingBox])
        weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
        all_data = {  origin: origin,
                      destination: destination,
                      route: route,
                      weather: weather}
        road_trip = RoadTrip.new(all_data)
        render json: RoadtripSerializer.new(road_trip)
      end
    elsif invalid_location_param(origin, destination)
      render_invalid_params
    else
      error = "Invalid request, please include valid parameters"
      render_error(error, :unauthorized)
    end
  end

  def invalid_location_param(origin, destination)
      return true if !origin || origin == ""
      return true if !destination || destination == ""
      return true if origin.match(/([^,]+)(, *)([a-z]{2})$/).nil?
      destination.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
