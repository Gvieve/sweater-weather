require 'rails_helper'

describe 'Background API' do
  describe 'background image by city' do
    describe 'happy path' do
      it "sends an image when provided a valid location" do
        VCR.use_cassette('requests/api/v1/background_denver') do
          location = 'denver,co'
          get "/api/v1/backgrounds?location=#{location}"

          json = JSON.parse(response.body, symbolize_names: true)

          expect(response).to be_successful
          expect(response.status).to eq(200)
          expect(json).to be_a(Hash)
          expect(json).to have_key(:data)
          expect(json[:data]).to have_key(:type)
          expect(json[:data][:type]).to eq('image')
          expect(json[:data]).to have_key(:id)
          expect(json[:data][:id]).to be_nil
          expect(json[:data]).to have_key(:attributes)
          expect(json[:data][:attributes]).to be_a(Hash)
          expect(json[:data][:attributes]).to have_key(:location)
          expect(json[:data][:attributes][:location]).to be_a(String)
          expect(json[:data][:attributes]).to have_key(:image_url)
          expect(json[:data][:attributes][:image_url]).to be_a(String)
          expect(json[:data][:attributes]).to have_key(:description)
          expect(json[:data][:attributes][:description]).to be_a(String)
          expect(json[:data][:attributes]).to have_key(:credit)
          expect(json[:data][:attributes][:credit]).to be_a(Hash)
          expect(json[:data][:attributes][:credit]).to have_key(:source)
          expect(json[:data][:attributes][:credit][:source]).to be_a(String)
          expect(json[:data][:attributes][:credit]).to have_key(:author)
          expect(json[:data][:attributes][:credit][:author]).to be_a(String)
          expect(json[:data][:attributes][:credit]).to have_key(:author_profile_url)
          expect(json[:data][:attributes][:credit][:author_profile_url]).to be_a(String)
        end
      end
    end

    describe 'sad path and edge cases' do
      it "returns an error when the location is missing" do
          get "/api/v1/backgrounds"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when the location is an empty string" do
          location = ''
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when the location only has state and no city" do
          location = ',co'
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when location only has city and no state" do
          location = 'denver'
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when location has city but state is not two characters" do
          location = 'denver, colorado'
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when location has city and state is not two characters" do
          location = 'denver'
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      it "returns an error when location there is no comma to separate city and state" do
          location = 'denver co'
          get "/api/v1/backgrounds?location=#{location}"

          expect(response).to_not be_successful
          json = JSON.parse(response.body, symbolize_names:true)

          expect(response.status).to eq(400)
          expect(json[:error]).to be_a(String)
          expect(json[:error]).to eq("Please include a valid location")
      end

      # it "returns an error when location returns mapquest default" do
      #   VCR.use_cassette('requests/api/v1/sad_default_path') do
      #     location = 'poajsdlnasgloip]asdiashd'
      #     get "/api/v1/backgrounds?location=#{location}"
      #
      #     expect(response).to_not be_successful
      #     json = JSON.parse(response.body, symbolize_names:true)
      #
      #     expect(response.status).to eq(400)
      #     expect(json[:error]).to be_a(String)
      #     expect(json[:error]).to eq("Please include a valid location")
      #   end
      # end
    end
  end
end
