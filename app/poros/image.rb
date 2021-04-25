class Image
  attr_reader :id,
              :location,
              :image_url,
              :description,
              :credit

  def initialize(location, data)
    @id = id
    @location = location.titleize
    @image_url = data[:urls][:regular]
    @description = data[:description]
    @credit = credit_info(data)
  end

  def credit_info(data)
    {
      source: 'unsplash.com',
      author: data[:user][:name],
      author_profile_url: data[:user][:links][:html]
    }
  end
end
