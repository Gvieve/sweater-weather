require 'rails_helper'

describe 'Forecast API' do
  describe 'forecast by city and state' do
    describe 'happy path' do
      it "sends the weather data when provided a valid location" do
        VCR.use_cassette('requests/api/v1/forecast') do
          location = 'denver,co'
          get "/api/v1/forecast?location=#{location}"

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(json).to be_a(Hash)
          expect(json).to have_key(:data)
          expect(json[:data]).to have_key(:id)
          expect(json[:data][:id]).to be_nil
          expect(json[:data]).to have_key(:attributes)
          expect(json[:data][:attributes]).to be_a(Hash)
          expect(json[:data][:attributes]).to have_key(:current_weather)
          expect(json[:data][:attributes][:current_weather]).to be_a(Hash)
          expect(json[:data][:attributes]).to have_key(:daily_weather)
          expect(json[:data][:attributes][:daily_weather]).to be_a(Array)
          expect(json[:data][:attributes][:daily_weather].first).to be_a(Hash)
          expect(json[:data][:attributes]).to have_key(:hourly_weather)
          expect(json[:data][:attributes][:hourly_weather]).to be_a(Array)
          expect(json[:data][:attributes][:hourly_weather].first).to be_a(Hash)
        end
      end

      describe 'the weather data for valid request includes' do
        before :each do
          VCR.use_cassette('requests/api/v1/forecast') do
            location = 'denver,co'
            get "/api/v1/forecast?location=#{location}"
            @json = JSON.parse(response.body, symbolize_names: true)
          end
        end

        it "current_weather data" do
          current = @json[:data][:attributes][:current_weather]

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(current).to be_a(Hash)
          expect(current).to have_key(:datetime)
          expect(current[:datetime]).to be_a(String)
          expect(current).to have_key(:sunrise)
          expect(current[:sunrise]).to be_a(String)
          expect(current).to have_key(:sunset)
          expect(current[:sunset]).to be_a(String)
          expect(current).to have_key(:temperature)
          expect(current[:temperature]).to be_a(Float).or be_an(Integer).or be_an(Integer)
          expect(current).to have_key(:feels_like)
          expect(current[:feels_like]).to be_a(Float).or be_an(Integer).or be_an(Integer)
          expect(current).to have_key(:humidity)
          expect(current[:humidity]).to be_a(Float).or be_an(Integer)
          expect(current).to have_key(:uvi)
          expect(current[:uvi]).to be_a(Float).or be_an(Integer)
          expect(current).to have_key(:visibility)
          expect(current[:visibility]).to be_a(Float).or be_an(Integer)
          expect(current).to have_key(:conditions)
          expect(current[:conditions]).to be_a(String)
          expect(current).to have_key(:icon)
          expect(current[:icon]).to be_a(String)
        end

        it "5 days of daily_weather data" do
          daily = @json[:data][:attributes][:daily_weather]

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(daily).to be_an(Array)
          expect(daily.count).to eq(5)
          expect(daily.first).to be_a(Hash)
          expect(daily.first).to have_key(:date)
          expect(daily.first[:date]).to be_a(String)
          expect(daily.first).to have_key(:sunrise)
          expect(daily.first[:sunrise]).to be_a(String)
          expect(daily.first).to have_key(:sunset)
          expect(daily.first[:sunset]).to be_a(String)
          expect(daily.first).to have_key(:max_temp)
          expect(daily.first[:max_temp]).to be_a(Float).or be_an(Integer)
          expect(daily.first).to have_key(:min_temp)
          expect(daily.first[:min_temp]).to be_a(Float).or be_an(Integer)
          expect(daily.first).to have_key(:conditions)
          expect(daily.first[:conditions]).to be_a(String)
          expect(daily.first).to have_key(:icon)
          expect(daily.first[:icon]).to be_a(String)
        end

        it "8 hours of hourly_weather data" do
          hourly = @json[:data][:attributes][:hourly_weather]

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(hourly).to be_an(Array)
          expect(hourly.count).to eq(8)
          expect(hourly.first).to be_a(Hash)
          expect(hourly.first).to have_key(:time)
          expect(hourly.first[:time]).to be_a(String)
          expect(hourly.first).to have_key(:temperature)
          expect(hourly.first[:temperature]).to be_a(Float).or be_an(Integer)
          expect(hourly.first).to have_key(:conditions)
          expect(hourly.first[:conditions]).to be_a(String)
          expect(hourly.first).to have_key(:icon)
          expect(hourly.first[:icon]).to be_a(String)
        end
      end
    end

    describe 'sad path' do
      it "returns an error when the location parameter is missing" do
        VCR.use_cassette('requests/api/v1/sad_path') do
          get "/api/v1/forecast"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
        end
      end

      it "returns an error when the location parameter is an empty string" do
        VCR.use_cassette('requests/api/v1/sad_path') do
          location = ''
          get "/api/v1/forecast?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
        end
      end

      it "returns an error when the location parameter returns mapquest default" do
        VCR.use_cassette('requests/api/v1/sad_default_path') do
          location = 'poajsdlnasgloip]asdiashd'
          get "/api/v1/forecast?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
        end
      end
    end
  end
end
