class Api::V1::RoadTripController < ApplicationController

  def create
    user = User.where(api_key: params[:api_key])
    origin = params[:origin]
    destination = params[:destination]

    if user && !invalid_location_param(origin, destination)
      route = MapquestService.routes(origin, destination)[:route]
      coords = Coordinate.new(route[:boundingBox])
      travel_time = route[:formattedTime].split(':')
      hour, minutes, seconds = travel_time
      if hour.to_i == 0
        #get minutely weather
      elsif hour.to_i > 48
        #get daily weather
      else
        #get hourly weather
      require "pry"; binding.pry
    end


  end

  def invalid_location_param(origin, destination)
      return true if !origin || origin == ""
      return true if !destination || destination == ""
      return true if origin.match(/([^,]+)(, *)([a-z]{2})$/).nil?
      destination.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
