### weather.rb
#
#
#
### Created by Bell_staymen02 on 2014/05/12.

require 'rubygems'
require 'weather_jp'
require 'twitter'
require 'tweetstream'


# -- Twitter ---

CONSUMER_KEY = ""
CONSUMER_SECRET = ""
ACCESS_TOKEN = ""
ACCESS_SECRET = ""

restclient = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONSUMER_KEY
    config.consumer_secret     = CONSUMER_SECRET
    config.access_token        = ACCESS_TOKEN
    config.access_token_secret = ACCESS_SECRET
end


TweetStream.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_SECRET
end

# --- Main ---

client = TweetStream::Client.new.track('@yourID') do |status|
    text = status.text
    if text.start_with? "RT"
        next
    elsif text =~ /^.*[[:blank:]]*[@＠]yourID[[:blank:]]*weather[[:blank:]]*/
        new_text = text.gsub(/^.*[[:blank:]]*[@＠]yourID[[:blank:]]*weather[[:blank:]]*/,"")
        a  = WeatherJp.get(new_text)
        weather = a.today.to_s
        tweet = "@#{status.user.screen_name} #{weather} "
        restclient.favorite(status.id)
        restclient.update(tweet, :in_reply_to_status_id => status.id)
    elsif text =~ /^.*[[:blank:]]*[@＠]yourID[[:blank:]]*tomorrow_weather[[:blank:]]*/
        new_text = text.gsub(/^.*[[:blank:]]*[@＠]yourID[[:blank:]]*tomorrow_weather[[:blank:]]*/,"")
        a  = WeatherJp.get(new_text)
        weather = a.tomorrow.to_s
        tweet = "@#{status.user.screen_name} #{weather} "
        restclient.favorite(status.id)
        restclient.update(tweet, :in_reply_to_status_id => status.id)
    end
end
