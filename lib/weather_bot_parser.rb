require 'open_weather'

# Class to handle requests to the weather API and build the string
# for tweeting
class WeatherBotParser
  class << self
    def forecast(location)
      location_forecast = OpenWeather::Forecast.city(location)
      if location_forecast['cod'] == '200'
        forecast_to_use = get_closest_forecast location_forecast['list']
        build_weather_string location, forecast_to_use
      else
        build_error_message location
      end
    end

    private

    def build_error_message(location)
      "We still can't tell you the weather for #{location}"
    end

    def build_weather_string(location, forecast)
      description = forecast['weather'][0]['description'].capitalize
      temperature = (forecast['main']['temp'] - 273.15).round 2
      "#{location}: #{description}. Temp: #{temperature}ºC"
    end

    def get_closest_forecast(list)
      current_timestamp = Time.now.to_i
      final_diff = 10_000_000
      final_forecast = nil

      list.each do |current_forecast|
        diff_time = (current_forecast['dt'] - current_timestamp).abs
        if final_forecast.nil? || diff_time < final_diff
          final_forecast = current_forecast
          final_diff = diff_time
        end
        return final_forecast if current_forecast['dt'] > final_forecast['dt']
      end

      final_forecast
    end
  end
end
