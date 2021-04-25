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
        require "pry"; binding.pry

        user = User.find_by(email: user_registration_body[:email])
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(user.email).to eq(user_registration_body[:email])
      end
    end
  end
end
