class RoadTripFacade

  def self.create_roadtrip(params)
    return 'unauthorized' if User.where(api_key: params[:api_key]).empty?
    origin = params[:origin]
    destination = params[:destination]
    return nil if invalid_location_param(origin, destination)
    data = all_data(origin, destination)
    RoadTrip.new(data)
  end

  private

  def self.get_route(origin, destination)
    route = MapquestService.routes(origin, destination)[:route]
    route[:routeError][:errorCode] == 2 ? nil : route
  end

  def self.get_weather(route)
    coords = Coordinate.new(route[:boundingBox])
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
  end

  def self.all_data(origin, destination)
    data = {
              origin: origin,
              destination: destination,
              route: get_route(origin, destination),
              weather: nil
            }
    data[:weather] = get_weather(data[:route]) if data[:route]
    data
  end

  def self.invalid_location_param(origin, destination)
    return true if !origin || origin == ""
    return true if !destination || destination == ""
    return true if origin.downcase.match(/([^,]+)(, *)([a-z]{2})$/).nil?
    destination.downcase.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
