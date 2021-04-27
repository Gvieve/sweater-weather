require 'rails_helper'

describe 'Forecast API' do
  describe 'road trip' do
    describe 'happy path' do
      before :each do
        @user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
      end

      it "provides travel time and weather within 48 hours upon arrival when given valid data" do
        VCR.use_cassette('requests/api/v1/roadtrip_denver_to_breckenridge') do
          route = { origin: 'denver, co',
                    destination:  'breckenridge, co',
                    api_key: @user1.api_key}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/road_trip", headers: headers, params: route.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(json).to be_a(Hash)
          expect(json).to have_key(:data)
          expect(json[:data]).to have_key(:id)
          expect(json[:data][:id]).to be_nil
          expect(json[:data]).to have_key(:type)
          expect(json[:data][:type]).to eq("roadtrip")
          expect(json[:data]).to have_key(:attributes)
          expect(json[:data][:attributes]).to be_a(Hash)
          expect(json[:data][:attributes]).to have_key(:start_city)
          expect(json[:data][:attributes][:start_city]).to be_a(String)
          expect(json[:data][:attributes][:start_city]).to eq(route[:origin])
          expect(json[:data][:attributes]).to have_key(:end_city)
          expect(json[:data][:attributes][:end_city]).to be_a(String)
          expect(json[:data][:attributes][:end_city]).to eq(route[:destination])
          expect(json[:data][:attributes]).to have_key(:travel_time)
          expect(json[:data][:attributes][:travel_time]).to be_a(String)
          expect(json[:data][:attributes]).to have_key(:weather_at_eta)
          expect(json[:data][:attributes][:weather_at_eta]).to be_a(Hash)
          expect(json[:data][:attributes][:weather_at_eta]).to have_key(:conditions)
          expect(json[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
          expect(json[:data][:attributes][:weather_at_eta]).to have_key(:temperature)
          expect(json[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float).or be_an(Integer)
        end
      end

      it "provides travel time and weather when trip is over 48 hours when given valid data" do
        VCR.use_cassette('requests/api/v1/roadtrip_anchorage_to_casper') do
          route = { origin: 'anchorage, ak',
                    destination:  'casper, wy',
                    api_key: @user1.api_key}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/road_trip", headers: headers, params: route.to_json

          result = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(result[:start_city]).to eq("#{route[:origin]}")
          expect(result[:end_city]).to eq("#{route[:destination]}")
          expect(result[:travel_time]).to eq("48 hours, 15 minutes")
          expect(result[:weather_at_eta]).to be_a(Hash)
          expect(result[:weather_at_eta]).to have_key(:temperature)
        end
      end

      it "provides travel time and weather when trip is less than 1 hour when given valid data" do
        VCR.use_cassette('requests/api/v1/roadtrip_denver_to_boulder') do
          route = { origin: 'denver, co',
                    destination:  'boulder, co',
                    api_key: @user1.api_key}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/road_trip", headers: headers, params: route.to_json

          result = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(result[:start_city]).to eq("#{route[:origin]}")
          expect(result[:end_city]).to eq("#{route[:destination]}")
          expect(result[:travel_time]).to eq("00 hours, 35 minutes")
          expect(result[:weather_at_eta]).to be_a(Hash)
          expect(result[:weather_at_eta]).to have_key(:temperature)
        end
      end
    end

    describe 'sad path' do
      it "returns no 401 error when the api key doesn't match any user" do
        route = { origin: 'denver, co',
                  destination:  'breckenridge, co',
                  api_key: "#{SecureRandom.hex(14)}"}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: route.to_json

        json = JSON.parse(response.body, symbolize_names:true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Invalid request, please include valid parameters")
      end

      it "returns no weather data when the trip is greater than 7 days" do
        VCR.use_cassette('requests/api/v1/roadtrip_london_to_capetown') do
          user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
          route = { origin: 'london, uk',
                    destination:  'capetown, za',
                    api_key: user1.api_key}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/road_trip", headers: headers, params: route.to_json

          result = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(result[:start_city]).to eq("#{route[:origin]}")
          expect(result[:end_city]).to eq("#{route[:destination]}")
          expect(result[:travel_time]).to eq("168 hours, 28 minutes")
          expect(result[:weather_at_eta]).to be_a(Hash)
          expect(result[:weather_at_eta].empty?).to eq(true)
        end
      end
    end
  end
end

    #   describe 'the weather data for valid request includes' do
    #     before :each do
    #       VCR.use_cassette('requests/api/v1/forecast') do
    #         location = 'denver,co'
    #         get "/api/v1/forecast?location=#{location}"
    #         @json = JSON.parse(response.body, symbolize_names: true)
    #       end
    #     end
    #
    #     it "current_weather data" do
    #       current = @json[:data][:attributes][:current_weather]
    #
    #       expect(response).to be_successful
    #       expect(response.status).to eq(200)
    #       expect(current).to be_a(Hash)
    #       expect(current).to have_key(:datetime)
    #       expect(current[:datetime]).to be_a(String)
    #       expect(current).to have_key(:sunrise)
    #       expect(current[:sunrise]).to be_a(String)
    #       expect(current).to have_key(:sunset)
    #       expect(current[:sunset]).to be_a(String)
    #       expect(current).to have_key(:temperature)
    #       expect(current[:temperature]).to be_a(Float).or be_an(Integer).or be_an(Integer)
    #       expect(current).to have_key(:feels_like)
    #       expect(current[:feels_like]).to be_a(Float).or be_an(Integer).or be_an(Integer)
    #       expect(current).to have_key(:humidity)
    #       expect(current[:humidity]).to be_a(Float).or be_an(Integer)
    #       expect(current).to have_key(:uvi)
    #       expect(current[:uvi]).to be_a(Float).or be_an(Integer)
    #       expect(current).to have_key(:visibility)
    #       expect(current[:visibility]).to be_a(Float).or be_an(Integer)
    #       expect(current).to have_key(:conditions)
    #       expect(current[:conditions]).to be_a(String)
    #       expect(current).to have_key(:icon)
    #       expect(current[:icon]).to be_a(String)
    #     end
    #
    #     it "5 days of daily_weather data" do
    #       daily = @json[:data][:attributes][:daily_weather]
    #
    #       expect(response).to be_successful
    #       expect(response.status).to eq(200)
    #       expect(daily).to be_an(Array)
    #       expect(daily.count).to eq(5)
    #       expect(daily.first).to be_a(Hash)
    #       expect(daily.first).to have_key(:date)
    #       expect(daily.first[:date]).to be_a(String)
    #       expect(daily.first).to have_key(:sunrise)
    #       expect(daily.first[:sunrise]).to be_a(String)
    #       expect(daily.first).to have_key(:sunset)
    #       expect(daily.first[:sunset]).to be_a(String)
    #       expect(daily.first).to have_key(:max_temp)
    #       expect(daily.first[:max_temp]).to be_a(Float).or be_an(Integer)
    #       expect(daily.first).to have_key(:min_temp)
    #       expect(daily.first[:min_temp]).to be_a(Float).or be_an(Integer)
    #       expect(daily.first).to have_key(:conditions)
    #       expect(daily.first[:conditions]).to be_a(String)
    #       expect(daily.first).to have_key(:icon)
    #       expect(daily.first[:icon]).to be_a(String)
    #     end
    #
    #     it "8 hours of hourly_weather data" do
    #       hourly = @json[:data][:attributes][:hourly_weather]
    #
    #       expect(response).to be_successful
    #       expect(response.status).to eq(200)
    #       expect(hourly).to be_an(Array)
    #       expect(hourly.count).to eq(8)
    #       expect(hourly.first).to be_a(Hash)
    #       expect(hourly.first).to have_key(:time)
    #       expect(hourly.first[:time]).to be_a(String)
    #       expect(hourly.first).to have_key(:temperature)
    #       expect(hourly.first[:temperature]).to be_a(Float).or be_an(Integer)
    #       expect(hourly.first).to have_key(:conditions)
    #       expect(hourly.first[:conditions]).to be_a(String)
    #       expect(hourly.first).to have_key(:icon)
    #       expect(hourly.first[:icon]).to be_a(String)
    #     end
    #   end
    # end
    #
    # describe 'sad path and edge cases' do
    #   it "returns an error when the location is missing" do
    #       get "/api/v1/forecast"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when the location is an empty string" do
    #       location = ''
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when the location only has state and no city" do
    #       location = ',co'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when location only has city and no state" do
    #       location = 'denver'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when location has city but state is not two characters" do
    #       location = 'denver, colorado'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when location has city and state is not two characters" do
    #       location = 'denver'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when location there is no comma to separate city and state" do
    #       location = 'denver co'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #   end
    #
    #   it "returns an error when location returns mapquest default" do
    #     VCR.use_cassette('requests/api/v1/sad_default_path') do
    #       location = 'poajsdlnasgloip]asdiashd'
    #       get "/api/v1/forecast?location=#{location}"
    #
    #       expect(response).to_not be_successful
    #       json = JSON.parse(response.body, symbolize_names:true)
    #
    #       expect(response.status).to eq(400)
    #       expect(json[:error]).to be_a(String)
    #       expect(json[:error]).to eq("Please include a valid location")
    #     end
    #   end
    # end
