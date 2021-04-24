class OpenWeatherService
  def self.conn
    Faraday.new('https://api.openweathermap.org') do |req|
      req.params['appid'] = ENV['open_weather_key']
    end
  end

  def self.forecast_by_location(lat, long, exclude = 'minutely', language = 'en', units = 'imperial')
    response = conn.get('/data/2.5/onecall') do |req|
      req.params['lat'] = lat
      req.params['lon'] = long
      req.params['exclude'] = exclude
      req.params['lang'] = language
      req.params['units'] = units
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
