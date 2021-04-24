class ForecastSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :current_weather,
              :daily_weather,
              :hourly_weather
# require "pry"; binding.pry
#   attribute :current_weather do |object|
#     object.current_weather
#   # attribute :daily_weather
#   # attribute :hourly_weather
end
