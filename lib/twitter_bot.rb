class TwitterBot < ActiveRecord::Base
  attr_accessible :newest_processed_mention_id
  NUMBER_TO_PROCESS = 200

  def self.process_new_mentions
    options = {count: NUMBER_TO_PROCESS}
    options.merge!({since_id: bobby.newest_processed_mention_id}) if bobby.newest_processed_mention_id
    mentions_to_process = get_mentions(options)
    mentions_to_process.each do |mention|
      p mention.from_user
      log_message_processed(mention)
      LoveRequest.process!(mention) unless should_be_ignored?(mention)
      pro.update_attributes(newest_processed_mention_id: mention.id)
    end
  end
  
  def self.bobby
    all.first || TwitterBot.create!
  end
  
  def self.invalidate_all_tweets
    mentions = get_mentions({count:1})
    processor.update_attributes(newest_processed_mention_id: mentions.first.id) if mentions.first
  end
  
  def self.tweet(love_request, image)
    api_user = Twitter::Client.new(
      :consumer_key => "km3qqeLxsDAPglsE5n4zRg",
      :consumer_secret => "2ZjZAJvnXKSZPzDKFVbBZ98yAtP9kWDhP30w7YYzw4",
      :oauth_token => love_request.user.token,
      :oauth_token_secret => love_request.user.secret
    )
    api_user.update_with_media(love_request.todays_message, image)
  end

  private

  def self.get_mentions(options)
    bot = Twitter::Client.new(
      :consumer_key => "km3qqeLxsDAPglsE5n4zRg",
      :consumer_secret => "2ZjZAJvnXKSZPzDKFVbBZ98yAtP9kWDhP30w7YYzw4",
      :oauth_token => "1209323317-hLKqJHIyBQZAjXfzUmp7YRWsnAYcbnFaQFNFKTm",
      :oauth_token_secret => "h9jDidOLH0uzzBz6kuzqB34NJ0NorClL8QD2wmpY"
    )
    bot.mentions_timeline(options)
  end

  def self.classic_retweet?(tweet_text)
    tweet_text =~ /rt\s?@/i
  end
  
  def self.log_message_processed(mention)
      logger.info "Processing mention from #{mention.user.screen_name}: #{mention.text}" unless ENV["RACK_ENV"] == "test"
  end
  
  def self.should_be_ignored?(mention)
    mention.retweeted || classic_retweet?(mention.text)
  end
end
