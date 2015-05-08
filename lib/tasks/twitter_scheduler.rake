require_relative '../twitter_client.rb'
require_relative '../weather_bot_parser.rb'

namespace :twitter do
  desc 'Send a tweet with some uninteresting content'
  task :send_tweet do
    TwitterClient.instance.send_tweet WeatherBotParser.forecast 'Oregano'
  end
end
