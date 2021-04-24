require 'rails_helper'

describe DailyWeather do
  describe 'happy path' do
    it "builds a DailyWeather PORO based on input" do
      VCR.use_cassette('poros/weather') do
        location = 'denver,co'
        data = MapquestService.location(location)[:results].first
        coords = Coordinate.new(data)
        @weather = OpenWeatherService.forecast_by_location(coords.latitude, coords.longitude)
      end
      daily = DailyWeather.new(@weather[:daily].first)

      expect(daily).to be_a(DailyWeather)
      expect(daily.date).to be_a(String)
      expect(daily.date).to eq(Time.at(@weather[:daily].first[:dt]).strftime("%Y-%m-%d"))
      expect(daily.sunrise).to be_a(String)
      expect(daily.sunrise).to eq(Time.at(@weather[:current][:sunrise]).to_s)
      expect(daily.sunset).to be_a(String)
      expect(daily.sunset).to eq(Time.at(@weather[:current][:sunset]).to_s)
      expect(daily.max_temp).to be_a(Float)
      expect(daily.min_temp).to be_a(Float)
      expect(daily.conditions).to be_a(String)
      expect(daily.icon).to be_a(String)
    end
  end
end
