require 'singleton'

class TwitterClient
  include Singleton

  def initialize
    @client ||= initialize_client
  end

  def send_tweet content
    @client.update content
  end

  private

  def initialize_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_secret
    end
  end
end
