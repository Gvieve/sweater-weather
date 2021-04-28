require 'rails_helper'

describe RoadTripFacade do
  describe 'happy path' do
    it "called Facade and got the roadtrip with valid parameters" do
      VCR.use_cassette('facades/roadtrip_denver_to_breckenridge') do
        user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
        @params = { origin: 'denver, co',
                  destination:  'breckenridge, co',
                  api_key: user1.api_key}
        @result = RoadTripFacade.create_roadtrip(@params)
      end

      expect(@result).to be_a(RoadTrip)
      expect(@result.id).to be_nil
      expect(@result.start_city).to eq(@params[:origin])
      expect(@result.end_city).to eq(@params[:destination])
      expect(@result.travel_time).to be_a(String)
      expect(@result.weather_at_eta).to be_a(Hash)
    end
  end
end
