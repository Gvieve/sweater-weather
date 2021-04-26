require 'rails_helper'

describe Coordinate do
  describe 'happy path' do
    it "builds a Coordinate PORO based on input" do
      VCR.use_cassette('poros/mapquest') do
        location = 'denver,co'
        @data = MapquestService.location(location)[:results].first
      end
      coordinate = Coordinate.new(@data)

      expect(coordinate).to be_a(Coordinate)
      expect(coordinate.latitude).to be_a(Float)
      expect(coordinate.longitude).to be_a(Float)
    end

    it "builds a Coordinate PORO based on route input" do
      VCR.use_cassette('poros/mapquest_routes') do
        start = 'denver, co'
        final_destination = 'breckenridge, co'
        @data = MapquestService.routes(start, final_destination)[:route]
      end
      coordinate = Coordinate.new(@data)

      expect(coordinate).to be_a(Coordinate)
      expect(coordinate.latitude).to be_a(Float)
      expect(coordinate.longitude).to be_a(Float)
    end
  end
end
