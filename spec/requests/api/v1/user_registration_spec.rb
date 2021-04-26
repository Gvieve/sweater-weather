require 'rails_helper'

describe 'User Registration API' do
  describe 'finds existing or creates user' do
    describe 'happy path' do
      it "creates a new user and generates api key when given valid request" do
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

    describe 'sad path/edge cases' do
      describe 'does not create a new user' do
        it "returns an error when email is missing" do
          user_registration_body = {
            password: 'littleone',
            password_confirmation: 'littleone'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please send a valid request, missing required information")
        end

        it "returns an error when password is missing" do
          user_registration_body = {
            email: 'jordiebear@email.com',
            password_confirmation: 'littleone'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please send a valid request, missing required information")
        end

        it "returns an error when password_confirmation is missing" do
          user_registration_body = {
            email: 'jordiebear@email.com',
            password: 'littleone'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please send a valid request, missing required information")
        end

        it "returns an error when password and password_confirmation don't match" do
          user_registration_body = {
            email: 'jordiebear@email.com',
            password: 'littleone',
            password_confirmation: 'babybear'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(404)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Validation failed: Password confirmation doesn't match Password")
        end

        it "returns an error when that user email already exists" do
          user_1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
          user_2_body = {
            email: 'jordiebear@email.com',
            password: 'babybear',
            password_confirmation: 'babybear'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_2_body.to_json

          user = User.last
          expect(user.id).to eq(user_1.id)

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(404)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Validation failed: Email has already been taken")
        end

        it "returns an error then the email is not a valid email format" do
          user_registration_body = {
            email: 'jordiebearemail.com',
            password: 'littleone',
            password_confirmation: 'littleone'
          }
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/users", headers: headers, params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(404)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Validation failed: Email is invalid")
        end

        it "returns an error when the request is not sent in json" do
          user_registration_body = {
            email: 'jordiebearemail.com',
            password: 'littleone',
            password_confirmation: 'littleone'
          }

          post "/api/v1/users", params: user_registration_body.to_json

          user = User.last
          expect(user).to be_nil

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please send a valid request, missing required information")
        end
      end
    end
  end
end
