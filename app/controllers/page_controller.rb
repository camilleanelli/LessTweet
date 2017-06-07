require 'twitter'
require 'net/http'
require 'json'

class PageController < ApplicationController

	def index
	end

	def show
		@client = Twitter::REST::Client.new do |config|
	  	config.consumer_key    = ENV['CONSUMER_KEY']
	  	config.consumer_secret = ENV['CONSUMER_SECRET']
	  	config.access_token    = ENV['TOKEN']
			config.access_token_secret = ENV['TOKEN_SECRET']
		end


		@input = params["user"]["screen_name"]
		if @input != ""
			@user = @client.user(@input)
			@tweets = @client.user_timeline(@user, count: 200)
			@account_creation = @user.created_at


			# "tweets of last 20 days---------------"
			@tweets_last_20_days = check_tweet_last_20_days(@tweets)

			# medium rate of tweets per days
			@tweets_rate = @tweets_last_20_days.count / 20

			# "Hours of tweets for the last 20 days"
			hours = check_tweet_hours(@tweets)
			hash_hours = Hash.new(0)
			hours.each { |e| hash_hours[e] += 1 }
			# puts hash_hours
			# puts @tweets_last_20_days

			# repeted hours > 2
				@repeted_hours = []
				hash_hours.each do |k, v|
					@repeted_hours << hash_hours.key(v) if v > 2
				end
				@repeted_hours

			# hash tweets per days for the last 20 days-----------"

			@tweet_count_per_day = Hash[ @tweets_last_20_days.group_by_day { |u| u.created_at.dup.utc.strftime("%Y-%m-%d") }.map { |k, v| ["#{k}", v.size] } ]



			# hash of last 20 days"

			range_of_dates = (3.week.ago.to_date..Date.today).map{ |date| date.strftime("%Y-%m-%d") }
			hash_date = {}
			range_of_dates.each do |date|
				hash_date[date] = nil
			end
			hash_date


			# puts "merged hash with new values-------------"
			new_hash_tweets = hash_date.merge(@tweet_count_per_day)

			# puts "final array of values on last 20 days.........."
			@array_of_values = []
			new_hash_tweets.each_value do |value|
				if value == nil
					value = 0
				end
				@array_of_values << value
			end
			@array_of_values

	 	else
			redirect_to root_path
		end
	end

	private


	def check_tweet_last_20_days(tweets)
		tweets_last_20_days = []
		tweets.each do |tweet|
			tweet_date = tweet.created_at.to_s
			if Date.parse(tweet_date) >= (Date.today - 20) #check for tweets the last 20 days
				tweets_last_20_days << tweet #include it in the array
			end
		end
		tweets_last_20_days
	end


	def check_tweet_hours(tweets)
		hours = []
		tweets.each do |tweet|
			tweet_date = tweet.created_at.to_s
			#check for dates during the last 20 days
			if Date.parse(tweet_date) >= (Date.today - 20)
				hours << tweet.created_at.strftime('%H:%M %P') #include dates in array
			end
		end
		hours
	end

end
