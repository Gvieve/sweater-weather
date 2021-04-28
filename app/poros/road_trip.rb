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

  private

  def format_travel_time(data)
    if data.nil?
      "impossible route"
    else
      time = data[:formattedTime].split(":")
      "#{time[0].to_i} hours, #{time[1].to_i} minutes"
    end
  end

  def get_weather(weather, route)
    current_time = weather[:current][:dt] unless weather.nil?
    arrival = arrival_time(current_time, route[:formattedTime]) unless route.nil?

    if @hours.to_i > 167 || weather.nil?
      {}
    elsif @hours.to_i > 47
      daily = daily_weather(weather, arrival)
      { temperature: daily.max_temp,
        conditions: daily.conditions }
    else
      hourly = hourly_weather(weather, arrival)
      { temperature: hourly.temperature,
        conditions: hourly.conditions }
    end
  end

  def arrival_time(current_time, travel_time_raw)
    times = travel_time_raw.split(":")
    @hours, minutes, seconds = times
    travel_seconds_elapsed = (@hours.to_i * 3600) + (minutes.to_i * 60)
    Time.at(current_time) + travel_seconds_elapsed
  end

  def daily_weather(weather, arrival)
    destination_weather = weather[:daily].find do |daily|
      Time.at(daily[:dt]).day == arrival.day
    end
    DailyWeather.new(destination_weather)
  end

  def hourly_weather(weather, arrival)
    arrival = arrival - ((arrival.min * 60) + arrival.sec) if arrival.min > 29
    destination_weather = weather[:hourly].find do |hourly|
      Time.at(hourly[:dt]) >= arrival
    end
    HourlyWeather.new(destination_weather)
  end
end
