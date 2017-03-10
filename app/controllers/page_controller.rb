require 'twitter'
require 'net/http'
require 'json'

class PageController < ApplicationController

	def index
	end

	def show

		client = Twitter::REST::Client.new do |config|
	  	config.consumer_key    = ENV['CONSUMER_KEY']
	  	config.consumer_secret = ENV['CONSUMER_SECRET']
	  	config.access_token    = ENV['TOKEN']
		config.access_token_secret = ENV['TOKEN_SECRET']
		end
		
		 
				@input = params["user"]["screen_name"]
				if @input != "" 
					@user = client.user(@input)

				
				@tweets =  client.user_timeline(@user)
				@last_tweet = @tweets.first
				@date_today = Date.today
				@last_thirty_days = @date_today - 30
	

				@tweet_count_per_day = Hash[ @tweets.group_by_day { |u| u.created_at.dup.utc }.map { |k, v| [k, v.size] } ]
				puts @tweet_count_per_day.inspect
				@tweet_count_per_day.each_value do |value|
				if value > 5
					puts "trop"
				else
					puts "ok"
				end
			end

			
				@tweets_last_thirty_days = []
				@tweets.each do |tweet|
					tweet_date = tweet.created_at.strftime("%Y-%m-%d")
					if Date.parse(tweet_date) >= @last_thirty_days 
						@tweets_last_thirty_days << tweet.text
					end
					@tweets_last_thirty_days	
				end
			
			puts @tweets.first.created_at
			puts @last_tweet.created_at
			
	
			puts @create = @user.created_at.strftime("%Y-%m-%d")
			puts Date.parse(@create) < @date_today
 		else
			redirect_to root_path
		end
	end

	private

	

	

end
