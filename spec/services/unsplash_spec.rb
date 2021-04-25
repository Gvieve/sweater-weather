require 'rails_helper'

describe UnsplashService do
  describe 'happy path' do
    it "tests the structure of the api data " do
      VCR.use_cassette('service/unsplash_denver') do
        location = 'denver,co'
        city_only = location.match(/^(.+?),/)[1]
        page = 1
        data = UnsplashService.photos_by_location(city_only, page)

        expect(data).to be_a(Hash)
        expect(data).to have_key(:results)
        expect(data[:results]).to be_an(Array)
        expect(data[:results].first).to have_key(:description)
        expect(data[:results].first[:description]).to be_a(String)
        expect(data[:results].first).to have_key(:urls)
        expect(data[:results].first[:urls]).to be_an(Hash)
        expect(data[:results].first[:urls]).to have_key(:regular)
        expect(data[:results].first[:urls][:regular]).to be_a(String)
        expect(data[:results].first[:user]).to have_key(:name)
        expect(data[:results].first[:user][:name]).to be_a(String)
        expect(data[:results].first[:user]).to have_key(:links)
        expect(data[:results].first[:user][:links]).to be_a(Hash)
        expect(data[:results].first[:user][:links]).to have_key(:html)
        expect(data[:results].first[:user][:links][:html]).to be_a(String)
      end
    end
  end
end
