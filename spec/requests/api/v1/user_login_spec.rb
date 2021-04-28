require 'rails_helper'

describe 'User Login API' do
  describe 'finds existing or confirms' do
    describe 'happy path' do
      before :each do
        @user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
      end
      it "confirms existing user credentials and sends api key when given valid request" do
        user_login_body = {email: 'jordiebear@email.com', password: 'littleone'}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/sessions", headers: headers, params: user_login_body.to_json


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
        expect(@user1.email).to eq(json[:data][:attributes][:email])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes][:api_key]).to be_a(String)
        expect(@user1.api_key).to eq(json[:data][:attributes][:api_key])
      end
    end

    describe 'sad path/edge cases' do
      describe 'does not login a user' do
        before :each do
          @user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
        end
        it "returns an error when email is missing" do
          user_login_body = {password: 'littleone'}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/sessions", headers: headers, params: user_login_body.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Invalid request, please include valid parameters")
        end

        it "returns an error when password is missing" do
          user_login_body = {email: 'jordiebear@email.com'}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/sessions", headers: headers, params: user_login_body.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Invalid request, please include valid parameters")
        end

        it "returns an error when password doesn't match" do
          user_login_body = {email: 'jordiebear@email.com', password: 'babybear'}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/sessions", headers: headers, params: user_login_body.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("The email or password you entered is incorrect")
        end

        it "returns an error when the email doesn't exist" do
          user_login_body = {email: 'mylittle@email.com', password: 'babybear'}
          headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

          post "/api/v1/sessions", headers: headers, params: user_login_body.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("The email or password you entered is incorrect")
        end

        it "returns an error when the request is not sent in json" do
          user_login_body = {email: 'jordiebearemail.com', password: 'littleone'}

          post "/api/v1/sessions", params: user_login_body.to_json

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to_not be_successful
          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Invalid request, please include valid parameters")
        end
      end
    end
  end
end
