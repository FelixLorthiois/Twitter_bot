require 'twitter'   # calls twitter gem

require 'dotenv'    # calls Dotenv gem
Dotenv.load('.env') # loads Dotenv file containing API keys in ENV hash
# puts ENV['TWITTER_API_SECRET']
# puts ENV['TWITTER_API_KEY']

=begin
# Connecting to twitter
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end
=end

# Connecting to twitter
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_API_KEY"]
  config.consumer_secret     = ENV["TWITTER_API_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end



# ligne qui permet de tweeter sur ton compte
 client.update('Hello World!')

#results = client.search("to:justinbieber marry me", result_type: "recent").take(3).collect do |tweet|
#  "#{tweet.user.screen_name}: #{tweet.text}"
#end

#puts results