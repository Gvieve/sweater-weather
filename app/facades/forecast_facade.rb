class ForecastFacade

  def self.get_forecast(params)
    location = params[:location]
    return nil if invalid_location_param(location)
    coords = get_coords(location)
    return nil if default_coords(coords)
    get_weather(coords)
  end

  def self.get_weather(coords)
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
    Forecast.new(weather)
  end


  def self.get_coords(location)
    data = MapquestService.location(location)[:results].first
    Coordinate.new(data)
  end

  def self.default_coords(coords)
    coords.latitude == 39.390897 && coords.longitude == -99.066067
  end

  def self.invalid_location_param(location)
    return true if !location || location == ""
    location.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
