require 'rails_helper'

describe OpenWeatherService do
  describe 'happy path' do
    before :each do
      VCR.use_cassette('service/mapquest_denver') do
        location = 'denver,co'
        info = MapquestService.location(location)
        @lat = info[:results].first[:locations].first[:latLng][:lat]
        @lon = info[:results].first[:locations].first[:latLng][:lng]
      end
    end

    it "tests the structure of the api data for all forecast types" do
      VCR.use_cassette('service/weather_denver') do
        data = OpenWeatherService.forecast_by_location(@lat, @lon)

        expect(data).to be_a(Hash)
        expect(data).to have_key(:current)
        expect(data[:current]).to be_a(Hash)
        expect(data).to have_key(:daily)
        expect(data[:daily]).to be_a(Array)
        expect(data).to have_key(:hourly)
        expect(data[:hourly]).to be_a(Array)
        expect(data).to_not have_key(:minutely)
      end
    end

    it "tests the api data for the current weather" do
      VCR.use_cassette('service/weather_denver') do
        data = OpenWeatherService.forecast_by_location(@lat, @lon)
        current = data[:current]

        expect(current).to have_key(:dt)
        expect(current[:dt]).to be_a(Integer)
        expect(current).to have_key(:sunrise)
        expect(current[:sunrise]).to be_a(Integer)
        expect(current).to have_key(:sunset)
        expect(current[:sunset]).to be_a(Integer)
        expect(current).to have_key(:temp)
        expect(current[:temp]).to be_a(Float)
        expect(current).to have_key(:feels_like)
        expect(current[:feels_like]).to be_a(Float)
        expect(current).to have_key(:humidity)
        expect(current[:humidity]).to be_a(Integer)
        expect(current).to have_key(:uvi)
        expect(current[:uvi]).to be_a(Float).or(be_an Integer)
        expect(current).to have_key(:visibility)
        expect(current[:visibility]).to be_a(Integer)
        expect(current).to have_key(:weather)
        expect(current[:weather]).to be_a(Array)
        expect(current[:weather].first).to have_key(:description)
        expect(current[:weather].first[:description]).to be_a(String)
        expect(current[:weather].first).to have_key(:icon)
        expect(current[:weather].first[:icon]).to be_a(String)
      end
    end

    it "tests the api data for daily weather" do
      VCR.use_cassette('service/weather_denver') do
        data = OpenWeatherService.forecast_by_location(@lat, @lon)
        daily = data[:daily]

        expect(daily.count).to eq(8)
        expect(daily.first).to have_key(:dt)
        expect(daily.first[:dt]).to be_a(Integer)
        expect(daily.first).to have_key(:sunrise)
        expect(daily.first[:sunrise]).to be_a(Integer)
        expect(daily.first).to have_key(:sunset)
        expect(daily.first[:sunset]).to be_a(Integer)
        expect(daily.first).to have_key(:temp)
        expect(daily.first[:temp]).to be_a(Hash)
        expect(daily.first[:temp]).to have_key(:min)
        expect(daily.first[:temp][:min]).to be_a(Float)
        expect(daily.first[:temp]).to have_key(:max)
        expect(daily.first[:temp][:max]).to be_a(Float)
        expect(daily.first).to have_key(:weather)
        expect(daily.first[:weather]).to be_a(Array)
        expect(daily.first[:weather].first).to have_key(:description)
        expect(daily.first[:weather].first[:description]).to be_a(String)
        expect(daily.first[:weather].first).to have_key(:icon)
        expect(daily.first[:weather].first[:icon]).to be_a(String)
      end
    end

    it "tests the api data for hourly weather" do
      VCR.use_cassette('service/weather_denver') do
        data = OpenWeatherService.forecast_by_location(@lat, @lon)
        hourly = data[:hourly]

        expect(hourly.count).to eq(48)
        expect(hourly.first).to have_key(:dt)
        expect(hourly.first[:dt]).to be_a(Integer)
        expect(hourly.first).to have_key(:temp)
        expect(hourly.first[:temp]).to be_a(Float)
        expect(hourly.first).to have_key(:weather)
        expect(hourly.first[:weather]).to be_a(Array)
        expect(hourly.first[:weather].first).to have_key(:description)
        expect(hourly.first[:weather].first[:description]).to be_a(String)
        expect(hourly.first[:weather].first).to have_key(:icon)
        expect(hourly.first[:weather].first[:icon]).to be_a(String)
      end
    end
  end
end
