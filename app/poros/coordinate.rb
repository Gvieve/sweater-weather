class Coordinate
  attr_reader :latitude,
              :longitude

  def initialize(data)
    @latitude = data[:locations].first[:latLng][:lat]
    @longitude = data[:locations].first[:latLng][:lng]
  end
end
