class Coordinate
  attr_reader :latitude,
              :longitude

  def initialize(data)
    @latitude = find_latitude(data)
    @longitude = find_longitude(data)
  end

  def find_latitude(data)
    if data[:locations]
      data[:locations].first[:latlng][:lat]
    else
      data[:ul][:lat]
    end
  end

  def find_longitude(data)
    if data[:locations]
      data[:locations].first[:latLng][:lng]
    else
      data[:ul][:lng]
    end
  end
end
