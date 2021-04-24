require 'rails_helper'

describe 'Forecast API' do
  describe 'forecast by city and state' do
    describe 'happy path' do
      it "sends the weather data when provided a valid location" do
        location = 'denver,co'
        get "/api/v1/forecast?#{location}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_null
        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:current_weather)
        expect(json[:data][:attributes][:current_weather]).to be_a(Hash)
      end
    end
  end
end
