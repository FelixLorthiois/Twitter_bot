require 'twitter'   # calls twitter gem
require 'pry'

require 'dotenv'    # calls Dotenv gem
Dotenv.load('.env') # loads Dotenv file containing API keys in ENV hash
# puts ENV['TWITTER_API_SECRET']
# puts ENV['TWITTER_API_KEY']

require_relative 'journalists' # calls the list of journalists

# Connecting to twitter
def login_twitter
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["TWITTER_API_KEY"]
    config.consumer_secret     = ENV["TWITTER_API_SECRET"]
    config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
  return client
end

# Connnecting to twitter stream
def stream_login_twitter
  client = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = ENV["TWITTER_API_KEY"]
    config.consumer_secret     = ENV["TWITTER_API_SECRET"]
    config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
  return client
end

# sends tweets to a list of users
def tweet_sender(client)
  handles = journalists.sample(5)
  handles.each do |handle|
    client.update("#{handle}, j\'adore votre travail, merci pour ce que vous faites. #bonjour_monde")
  end
end

# likes tweets containing a specific hashtag
def tweet_liker(client,hashtag)
  tweets = client.search("#{hashtag}", result_type: "recent").take(20)
  client.favorite(tweets)
end

# follows users who recently tweeted a specific hashtag
def tweet_follower(client,hashtag)
  tweets = client.search("#{hashtag}", result_type: "recent").take(50)
  user_ids = tweets.map {|tweet| tweet.user.id}.uniq
  user_ids.delete(client.user.id)    # removes from the list the client. I cannot follow myself
  binding.pry
  user_ids.each {|id| client.follow(id)}
end

# live likes twwets that contains a specific hashtag and follow their users
def stream_like_and_follow(client_rest,client_stream,hashtag)
  client_stream.filter(track: hashtag) do |object|
    if object.is_a?(Twitter::Tweet)
      puts object.text if object.is_a?(Twitter::Tweet)
      client_rest.favorite(object)
      puts "Je like le tweet suivant: \n #{object.text} \n"
      client_rest.follow(object.user.id)
      puts "Je follow l'auteur de ce tweet, à savoir #{object.user.name}"
    end
  end
end

# preform method
def perform
  client_rest = login_twitter
  client_stream = stream_login_twitter
  stream_like_and_follow(client_rest,client_stream,"#bonjour_monde")
end

perform
