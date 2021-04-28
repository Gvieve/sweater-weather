class ForecastFacade

  def self.get_forecast(params)
    location = params[:location]
    return nil if invalid_location_param(location)
    coords = get_coords(location)
    get_weather(coords)
  end

  def self.get_weather(coords)
    weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
    weather[:daily_limit] = 5
    weather[:hourly_limit] = 8
    Forecast.new(weather)
  end


  def self.get_coords(location)
    data = MapquestService.location(location)[:results].first
    Coordinate.new(data)
  end

  def self.invalid_location_param(location)
    return true if !location || location == ""
    location.downcase.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
