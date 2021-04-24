require 'rails_helper'

describe 'Forecast API' do
  describe 'forecast by city and state' do
    describe 'happy path' do
      it "sends the weather data when provided a valid location" do
        VCR.use_cassette('requests/api/v1/forecast') do
          location = 'denver,co'
          get "/api/v1/forecast?location=#{location}"

          json = JSON.parse(response.body, symbolize_names: true)
          # require "pry"; binding.pry
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

      it "the weather data has the current_weather data" do

      end
    end
  end
end
