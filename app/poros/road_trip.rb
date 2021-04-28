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
    @weather_at_eta = get_weather(data[:weather], data[:route])
  end

  def format_travel_time(data)
    if data.nil?
      "impossible route"
    else
      time = data[:formattedTime].split(":")
      "#{time[0]} hours, #{time[1]} minutes"
    end
  end

  def get_arrival_time(current_time, travel_time_raw)
    times = travel_time_raw.split(":")
    @hours, @minutes, seconds = times
    travel_seconds_elapsed = (@hours.to_i * 3600) + (@minutes.to_i * 60)
    Time.at(current_time) + travel_seconds_elapsed
  end

  def get_weather(weather, route)
    current_time = weather[:current][:dt] unless weather.nil?
    arrival_time = get_arrival_time(current_time, route[:formattedTime]) unless route.nil?
    if @hours.to_i > 167 || weather.nil?
      {}
    elsif @hours.to_i > 47
      daily = daily_weather(weather, arrival_time)
      { temperature: daily.max_temp,
        conditions: daily.conditions }
    else
      hourly = hourly_weather(weather, arrival_time)
      { temperature: hourly.temperature,
        conditions: hourly.conditions }
    end
  end

  def daily_weather(weather, arrival_time)
    destination_weather = weather[:daily].find do |daily|
      Time.at(daily[:dt]).day == arrival_time.day
    end
    DailyWeather.new(destination_weather)
  end

  def hourly_weather(weather, arrival_time)
    arrival_time = arrival_time - (arrival_time.min * 60) if arrival_time.min > 29
    destination_weather = weather[:hourly].find do |hourly|
      Time.at(hourly[:dt]) > arrival_time
    end
    HourlyWeather.new(destination_weather)
  end
end
