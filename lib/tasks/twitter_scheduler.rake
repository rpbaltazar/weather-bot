desc "Send a tweet with some uninteresting content"
task :send_tweet => :environment do
  TwitterClient.instance.send_tweet Utils.random_string 10
end