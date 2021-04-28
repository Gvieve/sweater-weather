class Api::V1::RoadTripController < ApplicationController

  def create
    road_trip = RoadTripFacade.create_roadtrip(params)
    if road_trip == 'unauthorized'
      error = "Invalid request, please include valid parameters"
      render_error(error, :unauthorized)
    elsif road_trip.nil?
      render_invalid_params
    else
      render json: RoadtripSerializer.new(road_trip)
    end
  end
end
