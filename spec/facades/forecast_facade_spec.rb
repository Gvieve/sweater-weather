require 'rails_helper'

describe ForecastFacade do
  describe 'happy path' do
    it "called Facade and got the forecast with valid location" do
      VCR.use_cassette('facades/forecast_denver') do
        params = ({ location: 'denver, co' })
        @result = ForecastFacade.get_forecast(params)
      end

      expect(@result).to be_a(Forecast)
      expect(@result.id).to be_nil
      expect(@result.current_weather).to be_an(CurrentWeather)
      expect(@result.daily_weather.count).to eq(5)
      expect(@result.daily_weather).to be_an(Array)
      expect(@result.daily_weather.first).to be_an(DailyWeather)
      expect(@result.hourly_weather.count).to eq(8)
      expect(@result.hourly_weather).to be_an(Array)
      expect(@result.hourly_weather.first).to be_an(HourlyWeather)
    end
  end
end
