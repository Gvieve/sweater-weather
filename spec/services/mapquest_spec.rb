require 'rails_helper'

describe MapquestService do
  describe 'happy path' do
    describe 'get coordinates by city and state' do
      it "tests the structure of the api data " do
        VCR.use_cassette('service/mapquest_denver') do
          location = 'denver,co'
          data = MapquestService.location(location)

          expect(data).to be_a(Hash)
          expect(data).to have_key(:results)
          expect(data[:results]).to be_an(Array)
          expect(data[:results].first).to have_key(:locations)
          expect(data[:results].first[:locations]).to be_an(Array)
          expect(data[:results].first[:locations].first).to have_key(:latLng)
          expect(data[:results].first[:locations].first[:latLng]).to be_a(Hash)
          expect(data[:results].first[:locations].first[:latLng].count).to eq(2)
          expect(data[:results].first[:locations].first[:latLng]).to have_key(:lat)
          expect(data[:results].first[:locations].first[:latLng][:lat]).to be_a(Float)
          expect(data[:results].first[:locations].first[:latLng]).to have_key(:lng)
          expect(data[:results].first[:locations].first[:latLng][:lng]).to be_a(Float)
        end
      end
    end

    describe 'get route time for search between two destinations' do
      it "tests the structure of the api data" do
        VCR.use_cassette('service/mapquest_denver_to_breckenridge') do
          start = 'denver, co'
          final_destination = 'breckenridge, co'
          data = MapquestService.routes(start, final_destination)

          expect(data).to be_a(Hash)
          expect(data).to have_key(:route)
          expect(data[:route]).to have_key(:boundingBox)
          expect(data[:route][:boundingBox]).to be_a(Hash)
          expect(data[:route][:boundingBox]).to have_key(:ul)
          expect(data[:route][:boundingBox][:ul]).to be_a(Hash)
          expect(data[:route][:boundingBox]).to have_key(:ul)
          expect(data[:route][:boundingBox][:ul]).to have_key(:lng)
          expect(data[:route][:boundingBox][:ul][:lng]).to be_a(Float)
          expect(data[:route][:boundingBox][:ul]).to have_key(:lat)
          expect(data[:route][:boundingBox][:ul][:lat]).to be_a(Float)
          expect(data[:route]).to have_key(:formattedTime)
          expect(data[:route][:formattedTime]).to be_a(String)
          expect(data[:route]).to have_key(:routeError)
          expect(data[:route][:routeError]).to be_a(Hash)
          expect(data[:route][:routeError]).to have_key(:errorCode)
          expect(data[:route][:routeError][:errorCode]).to_not eq(2)
        end
      end
    end

    describe 'sad path' do
      it "returns a error code when the route is impossible" do
        VCR.use_cassette('service/mapquest_denver_to_london') do
          start = 'denver, co'
          final_destination = 'london, uk'
          data = MapquestService.routes(start, final_destination)

          expect(data).to be_a(Hash)
          expect(data).to have_key(:route)
          expect(data[:route]).to have_key(:routeError)
          expect(data[:route][:routeError]).to be_a(Hash)
          expect(data[:route][:routeError]).to have_key(:errorCode)
          expect(data[:route][:routeError][:errorCode]).to eq(2)
        end
      end
    end
  end
end
