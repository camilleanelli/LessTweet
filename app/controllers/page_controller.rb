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
			@tweets = @client.user_timeline(@user)
			@tweets_count = @tweets.count
			@account_creation = @user.created_at
			

			puts "tweets of last 30 days---------------"
			@tweets_last_30_days = check_tweet_last_30_days(@tweets)
			puts @tweets_last_30_days

			puts "hash tweets per days for the last 30 days-----------"
			
			@tweet_count_per_day = Hash[ @tweets_last_30_days.group_by_day { |u| u.created_at.dup.utc }.map { |k, v| ["#{k}", v.size] } ]
			puts @tweet_count_per_day.inspect

			puts "hash of last 30 days--------------"
				
			@range_of_dates = (1.month.ago.to_date..Date.today).map{ |date| date.strftime("%Y-%m-%d") }
			hash_date = {}
			@range_of_dates.each do |date|
				hash_date[date] = nil
			end
			puts @hash_date
				

			puts "merged hash with new values-------------"
			new_hash_tweets =  hash_date.merge(@tweet_count_per_day)
			puts new_hash_tweets
			

			puts "final array of values on 30 days.........."
			@array_of_values = []
			new_hash_tweets.each_value do |value|
				if value == nil
					value = 0
				end
				@array_of_values << value
			end
		

			puts @array_of_values.inspect

	 		else
				redirect_to root_path
			end
		end

	private


	def check_tweet_last_30_days(tweets)
		date_today = Date.today
		last_thirty_days = date_today - 30
		tweets_last_thirty_days = []
		tweets.each do |tweet|
			tweet_date = tweet.created_at.strftime("%Y-%m-%d")
			if Date.parse(tweet_date) >= last_thirty_days 
				tweets_last_thirty_days << tweet
			end
		end
		tweets_last_thirty_days
	end

end
