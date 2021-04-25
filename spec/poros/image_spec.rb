require 'rails_helper'

describe Image do
  describe 'happy path' do
    it "builds a DailyWeather PORO based on input" do
      VCR.use_cassette('poros/image') do
        @location = 'denver,co'
        city_only = @location.match(/^(.+?),/)[1]
        @data = UnsplashService.photos_by_location(city_only)
      end
      image = Image.new(@location, @data[:results].first)

      expect(image).to be_a(Image)
      expect(image.location).to be_a(String)
      expect(image.image_url).to be_a(String)
      expect(image.description).to be_a(String)
      expect(image.credit).to be_a(Hash)
      expect(image.credit[:source]).to be_a(String)
      expect(image.credit[:author]).to be_a(String)
      expect(image.credit[:author_profile_url]).to be_a(String)
    end
  end
end
