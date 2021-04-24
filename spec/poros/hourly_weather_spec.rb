require 'rails_helper'

describe HourlyWeather do
  describe 'happy path' do
    it "builds a CurrentWeather PORO based on input" do
      VCR.use_cassette('poro/current_weather') do
        location = 'denver,co'
        data = MapquestService.location(location)[:results].first
        coords = Coordinate.new(data)
        @weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      end
      hourly = HourlyWeather.new(@weather[:hourly].first)

      expect(hourly).to be_a(HourlyWeather)
      expect(hourly.time).to be_a(String)
      expect(hourly.time).to eq(Time.at(@weather[:hourly].first[:dt]).strftime("%H:%M:%S"))
      expect(hourly.temperature).to be_a(Float)
      expect(hourly.conditions).to be_a(String)
      expect(hourly.icon).to be_a(String)
    end
  end
end
