require 'rails_helper'

describe CurrentWeather do
  describe 'happy path' do
    it "builds a CurrentWeather PORO based on input" do
      VCR.use_cassette('poro/current_weather') do
        location = 'denver,co'
        data = MapquestService.location(location)[:results].first
        coords = Coordinate.new(data)
        @weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      end
      current = CurrentWeather.new(@weather[:current])

      expect(current).to be_a(CurrentWeather)
      expect(current.datetime).to be_a(String)
      expect(current.datetime).to eq(Time.at(@weather[:current][:dt]).to_s)
      expect(current.sunrise).to be_a(String)
      expect(current.sunrise).to eq(Time.at(@weather[:current][:sunrise]).to_s)
      expect(current.sunset).to be_a(String)
      expect(current.sunset).to eq(Time.at(@weather[:current][:sunset]).to_s)
      expect(current.temperature).to be_a(Float)
      expect(current.feels_like).to be_a(Float)
      expect(current.humidity).to be_a(Float).or be_an(Integer)
      expect(current.uvi).to be_a(Float).or be_an(Integer)
      expect(current.visibility).to be_a(Float).or be_an(Integer)
      expect(current.conditions).to be_a(String)
      expect(current.icon).to be_a(String)
    end
  end
end
