namespace :twitter do
  desc 'Send a tweet with some uninteresting content'
  task send_tweet: :environment do
    TwitterClient.instance.send_tweet WeatherBotParser.forecast 'Coimbra, PT'
  end
end
