# @twitter_consumer_key    = Rails.application.secrets.twitter_consumer_key || ENV["TWITTER_CONSUMER_KEY"]
# @twitter_consumer_secret = Rails.application.secrets.twitter_consumer_secret || ENV["TWITTER_CONSUMER_SECRET"]
# @twitter_access_token    = Rails.application.secrets.twitter_access_token || ENV["TWITTER_ACCESS_TOKEN"]
# @twitter_access_secret   = Rails.application.secrets.twitter_access_secret || ENV["TWITTER_ACCESS_SECRET"]
#
# @twitter_handler = ENV["TWITTER_HANDLER"] || "@hi_weather_bot"
#
# TweetStream.configure do |config|
#   config.consumer_key        = @twitter_consumer_key
#   config.consumer_secret     = @twitter_consumer_secret
#   config.oauth_token         = @twitter_access_token
#   config.oauth_token_secret  = @twitter_access_secret
# end
#
# @stream_client = TweetStream::Client.new
#
# @stream_client.userstream do |status|
#   if status.text.include? @twitter_handler
#     user_to_mention = status.user.screen_name
#     place = status.text.gsub(@twitter_handler, "").strip
#     forecast_answer = WeatherBotParser.forecast place
#     TwitterClient.instance.reply_to_with status.id, "@#{user_to_mention} #{forecast_answer}"
#   end
# end
#
TwitterStreamClient.instance.listen_to_mentions
