class UnsplashService
  def self.conn
    Faraday.new('https://api.unsplash.com') do |req|
      req.headers['Authorization'] = "Client-ID #{ENV['unsplash_key']}"
    end
  end

  def self.photos_by_location(location)
    response = conn.get('/search/photos') do |req|
      req.params['query'] = location
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
