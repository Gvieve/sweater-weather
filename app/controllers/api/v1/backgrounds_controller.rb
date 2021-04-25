class Api::V1::BackgroundsController < ApplicationController

  def index
    return invalid_location if invalid_location_param(location)
    city = location.match(/^(.+?),/)[1]
    data = UnsplashService.photos_by_location(city)[:results].first
    image = Image.new(location, data)
    render json: ImageSerializer.new(image)
    require "pry"; binding.pry
  end

  private

  def invalid_location
    error = "Please include a valid location"
    render_error(error)
  end

  def invalid_location_param(location_city)
    return true if !location || location == ""
    location.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end

  def location
    params[:location]
  end
end
