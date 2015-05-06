require 'singleton'

# Twitter client configurator and comunicator.
# Uses Twitter gem as wrapper to send updates to the
# configured account
class TwitterClient
  include Singleton

  def initialize
    @twitter_consumer_key    = Rails.application.secrets.twitter_consumer_key || ENV['TWITTER_CONSUMER_KEY']
    @twitter_consumer_secret = Rails.application.secrets.twitter_consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
    @twitter_access_token    = Rails.application.secrets.twitter_access_token || ENV['TWITTER_ACCESS_TOKEN']
    @twitter_access_secret   = Rails.application.secrets.twitter_access_secret || ENV['TWITTER_ACCESS_SECRET']
    @client ||= initialize_client

    @stream_client_config ||= initialize_stream_client
    @stream_client ||= TweetStream::Client.new
    @twitter_handler = ENV["TWITTER_HANDLER"] || "@hi_weather_bot"
  end

  def send_tweet(content)
    @client.update content
  end

  def reply_to_with tweet_id, content
    @client.update content, in_reply_to_status_id: tweet_id
  end

  def listen_to_mentions
    @stream_client.userstream do |status|
      if status.text.include? @twitter_handler
        user_to_mention = status.user.screen_name
        place = status.text.gsub(@twitter_handler, "").strip
        forecast_answer = WeatherBotParser.forecast place
        TwitterClient.instance.reply_to_with status.id, "@#{user_to_mention} #{forecast_answer}"
      end
    end
  end

  private

  def initialize_stream_client
    TweetStream.configure do |config|
      config.consumer_key        = @twitter_consumer_key
      config.consumer_secret     = @twitter_consumer_secret
      config.oauth_token         = @twitter_access_token
      config.oauth_token_secret  = @twitter_access_secret
    end
  end

  def initialize_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = @twitter_consumer_key
      config.consumer_secret     = @twitter_consumer_secret
      config.access_token        = @twitter_access_token
      config.access_token_secret = @twitter_access_secret
    end
  end
end
