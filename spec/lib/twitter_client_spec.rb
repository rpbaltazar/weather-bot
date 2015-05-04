require 'spec_helper'

describe TwitterClient do
  let!(:twitter_client_instance) { TwitterClient.instance }
  let!(:fake_client) { twitter_client_instance.instance_variable_get :@client }
  let(:tweet_content) { "random words of wisdom" }

  describe "send_tweet" do
    it "sends a tweet update" do
      expect(fake_client).to receive(:update).exactly(1).times.with(tweet_content)
      twitter_client_instance.send_tweet tweet_content
    end
  end
end
