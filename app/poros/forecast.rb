class Forecast
  attr_reader :id,
              :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(data)
    @id = id
    @current_weather = CurrentWeather.new(data[:current])
    @daily_weather = daily(data[:daily])
    @hourly_weather = hourly(data[:hourly])
  end

  def daily(data)
    # require "pry"; binding.pry
    data.first(5).map do |day|
      DailyWeather.new(day)
    end
  end

  def hourly(data)
    data.first(8).map do |hour|
      HourlyWeather.new(hour)
    end
  end
end
