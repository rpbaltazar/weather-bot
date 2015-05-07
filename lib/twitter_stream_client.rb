require 'singleton'

class TwitterStreamClient
  include Singleton

  def initialize
    @twitter_handler = ENV["TWITTER_HANDLER"] || "@hi_weather_bot"
    @twitter_consumer_key    = Rails.application.secrets.twitter_consumer_key || ENV["TWITTER_CONSUMER_KEY"]
    @twitter_consumer_secret = Rails.application.secrets.twitter_consumer_secret || ENV["TWITTER_CONSUMER_SECRET"]
    @twitter_access_token    = Rails.application.secrets.twitter_access_token || ENV["TWITTER_ACCESS_TOKEN"]
    @twitter_access_secret   = Rails.application.secrets.twitter_access_secret || ENV["TWITTER_ACCESS_SECRET"]

    @stream_client ||= initialize_stream_client
  end

  def listen_to_mentions
    return if @stream_client.credentials?
    @stream_client.user do |status|
      case status
      when Twitter::Tweet
        if status.text.include? @twitter_handler
          user_to_mention = status.user.screen_name
          place = status.text.gsub(@twitter_handler, "").strip
          forecast_answer = WeatherBotParser.forecast place
          TwitterClient.instance.reply_to_with status.id, "@#{user_to_mention} #{forecast_answer}"
        end
      end
    end
  end

  private

  def initialize_stream_client
    # TweetStream.configure do |config|
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = @twitter_consumer_key
      config.consumer_secret     = @twitter_consumer_secret
      config.access_token         = @twitter_access_token
      config.access_token_secret  = @twitter_access_secret
    end
  end
end
