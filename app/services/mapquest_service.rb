class MapquestService
  def self.conn
    Faraday.new('https://www.mapquestapi.com') do |req|
      req.params['key'] = ENV['mapquest_key']
    end
  end

  def self.location(location)
    response = conn.get('/geocoding/v1/address') do |req|
      req.params['location'] = location
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
