require 'rails_helper'

describe Forecast do
  describe 'happy path' do
    it "builds a Forecast PORO based on input" do
      VCR.use_cassette('poros/weather') do
        location = 'denver,co'
        data = MapquestService.location(location)[:results].first
        coords = Coordinate.new(data)
        @weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      end
      @weather[:daily_limit] = 5
      @weather[:hourly_limit] = 8
      forecast = Forecast.new(@weather)

      expect(forecast).to be_a(Forecast)
      expect(forecast.id).to be_nil
      expect(forecast.current_weather).to be_a(CurrentWeather)
      expect(forecast.daily_weather.count).to eq(5)
      expect(forecast.daily_weather).to be_an(Array)
      expect(forecast.daily_weather.first).to be_an(DailyWeather)
      expect(forecast.hourly_weather.count).to eq(8)
      expect(forecast.hourly_weather).to be_an(Array)
      expect(forecast.hourly_weather.first).to be_an(HourlyWeather)
    end
  end
end
