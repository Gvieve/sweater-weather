class RoadTrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta

  def initialize(data)
    @id = id
    @start_city = data[:origin]
    @end_city = data[:destination]
    @travel_time = data[:route][:formattedTime]
    @arrival_time = calculate_arrival_time(data[:weather][:current][:dt])
    @weather_at_eta = get_forecast(data[:weather])
  end

  def calculate_arrival_time(current_time)
    times = @travel_time.split(":")
    @hours, @minutes, seconds = times
    travel_seconds_elapsed = (@hours.to_i * 3600) + (@minutes.to_i * 60)
    Time.at(current_time) + travel_seconds_elapsed
  end

  def get_weather(weather)
    if @hours.to_i > 167
      nil
    elsif @hours.to_i > 47
      destination_weather = weather[:daily].find do |daily|
        require "pry"; binding.pry
        Time.at(daily[:dt]) > @arrival_time
      end
      DailyWeather.new(destination_weather)
    else
      destination_weather = weather[:hourly].find do |hourly|
        Time.at(hourly[:dt]) > @arrival_time
      end
      HourlyWeather.new(destination_weather)
    end
  end

  def get_forecast(weather)
    weather = get_weather(weather)
    # require "pry"; binding.pry
    if !weather.nil?
      { temperature: weather.temperature,
        conditions: weather.conditions}
    else
      {}
    end
  end
end
