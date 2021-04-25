require 'rails_helper'

describe 'User Registration API' do
  describe 'finds existing or creates user' do
    describe 'happy path' do
      it "creates a new user and generates api key" do
        user_registration_body = {
          email: 'jordiebear@email.com',
          password: 'littleone',
          password_confirmation: 'littleone'
        }
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/users", headers: headers, params: user_registration_body.to_json

        user = User.last
        expect(user.email).to eq(user_registration_body[:email])

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response.content_type).to eq("application/json")
        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)
        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to eq('users')
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_a(String)
        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:email)
        expect(json[:data][:attributes][:email]).to be_a(String)
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes][:api_key]).to be_a(String)
        expect(json[:data][:attributes][:api_key].length).to eq(28)
      end
    end
  end
end
