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

      it "returns no weather data and when the trip is impossible" do
        VCR.use_cassette('requests/api/v1/roadtrip_denver_to_london') do
          user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
          route = { origin: 'denver, co',
                    destination:  'london, uk',
                    api_key: user1.api_key}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/road_trip", headers: headers, params: route.to_json

          result = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(result[:start_city]).to eq("#{route[:origin]}")
          expect(result[:end_city]).to eq("#{route[:destination]}")
          expect(result[:travel_time]).to eq("impossible route")
          expect(result[:weather_at_eta]).to be_a(Hash)
          expect(result[:weather_at_eta].empty?).to eq(true)
        end
      end

      it "returns a 401 error when the api key doesn't match any user" do
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

      it "returns an error when the origin is invalid location (city, st)" do
        user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
        route = { origin: 'denver',
                  destination:  'breckenridge, co',
                  api_key: user1.api_key}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: route.to_json

        json = JSON.parse(response.body, symbolize_names:true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Invalid request, please include valid parameters")
      end

      it "returns an error when the destination is invalid location (city, st)" do
        user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
        route = { origin: 'denver',
                  destination:  'breckenridge, co',
                  api_key: user1.api_key}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/road_trip", headers: headers, params: route.to_json

        json = JSON.parse(response.body, symbolize_names:true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Invalid request, please include valid parameters")
      end
    end
  end
end
