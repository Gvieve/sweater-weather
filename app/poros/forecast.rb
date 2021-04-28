class Forecast
  attr_reader :id,
              :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(data)
    @id = id
    @current_weather = CurrentWeather.new(data[:current])
    @daily_weather = daily(data[:daily], data[:daily_limit])
    @hourly_weather = hourly(data[:hourly], data[:hourly_limit])
  end

  def daily(data, limit)
    data.first(limit).map do |day|
      DailyWeather.new(day)
    end
  end

  def hourly(data, limit)
    data.first(limit).map do |hour|
      HourlyWeather.new(hour)
    end
  end
end
