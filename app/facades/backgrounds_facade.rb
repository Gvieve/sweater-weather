class BackgroundsFacade

  def self.find_background(params)
    location = params[:location]
    return nil if invalid_location_param(location)
    city = location.split(",").first
    data = UnsplashService.photos_by_location(city)[:results].first
    Image.new(location, data)
  end

  private

  def self.invalid_location_param(location)
    return true if !location || location == ""
    location.match(/([^,]+)(, *)([a-z]{2})$/).nil?
  end
end
