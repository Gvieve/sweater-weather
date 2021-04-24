class Forecast
  attr_reader :current,
              :daily,
              :hourly

  def initialize(data)
    @current = CurrentWeather.new(data[:current])
    @daily = daily_weather(data)
    @hourly = hourly_weather(data)
  end

  def daily_weather(data)
    data[:daily][0..4].map do |day|
      DailyWeather.new(day)
    end
  end

  def hourly_weather(data)
    data[:hourly][0..7].map do |hour|
      HourlyWeather.new(hour)
    end
  end
end
