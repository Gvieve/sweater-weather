require 'rails_helper'

describe Forecast do
  describe 'happy path' do
    it "builds a Forecast PORO based on input" do
      VCR.use_cassette('poro/current_weather') do
        location = 'denver,co'
        data = MapquestService.location(location)[:results].first
        coords = Coordinate.new(data)
        @weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      end

      forecast = Forecast.new(@weather)

      expect(forecast).to be_a(Forecast)
      expect(forecast.current).to be_a(CurrentWeather)
      expect(forecast.daily.count).to eq(5)
      expect(forecast.daily).to be_an(Array)
      expect(forecast.daily.first).to be_an(DailyWeather)
      expect(forecast.hourly.count).to eq(8)
      expect(forecast.hourly).to be_an(Array)
      expect(forecast.hourly.first).to be_an(HourlyWeather)
    end
  end
end
