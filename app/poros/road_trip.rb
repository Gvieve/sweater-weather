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
    @travel_time = format_travel_time(data[:route])
    @travel_time_raw = data[:route][:formattedTime]
    @arrival_time = calculate_arrival_time(data[:weather][:current][:dt])
    @weather_at_eta = get_forecast(data[:weather])
  end

  def format_travel_time(data)
    if data.nil?
      "impossible route"
    else
      time = data[:formattedTime].split(":")
      "#{time[0]} hours, #{time[1]} minutes"
    end
  end

  def calculate_arrival_time(current_time)
    times = @travel_time_raw.split(":")
    @hours, @minutes, seconds = times
    travel_seconds_elapsed = (@hours.to_i * 3600) + (@minutes.to_i * 60)
    Time.at(current_time) + travel_seconds_elapsed
  end

  def get_weather(weather)
    if @hours.to_i > 167
      nil
    elsif @hours.to_i > 47
      destination_weather = weather[:daily].find do |daily|
        Time.at(daily[:dt]).day == @arrival_time.day
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
    if !weather.nil?
      if weather.class == HourlyWeather
        { temperature: weather.temperature,
          conditions: weather.conditions }
      else
        { temperature: weather.max_temp,
          conditions: weather.conditions }
      end
    else
      {}
    end
  end
end
