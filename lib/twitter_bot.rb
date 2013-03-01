class TwitterBot < ActiveRecord::Base
  attr_accessible :newest_processed_mention_id
  NUMBER_TO_PROCESS = 200

  def self.process_new_mentions
    options = {count: NUMBER_TO_PROCESS}
    options.merge!({since_id: processor.newest_processed_mention_id}) if processor.newest_processed_mention_id
    mentions_to_process = get_mentions(options)
    mentions_to_process.each do |mention|
      log_message_processed(mention)
      LoveRequest.new(mention).process! unless should_be_ignored?(mention)
      processor.update_attributes(newest_processed_mention_id: mention.id)
    end      
  end
  
  def self.bobby
    all.first || TwitterBot.create!
  end
  
  def self.invalidate_all_tweets
    mentions = get_mentions({count:1})
    processor.update_attributes(newest_processed_mention_id: mentions.first.id) if mentions.first
  end
  
  def tweet
    
  end

  private

  def get_mentions(options)
    configure_twitter
    Twitter.mentions_timeline(options)
  end

  def configure_twitter
    Twitter.configure do |config|
      config.consumer_key = "km3qqeLxsDAPglsE5n4zRg"
      config.consumer_secret = "2ZjZAJvnXKSZPzDKFVbBZ98yAtP9kWDhP30w7YYzw4"
      config.oauth_token = "1209323317-hLKqJHIyBQZAjXfzUmp7YRWsnAYcbnFaQFNFKTm"
      config.oauth_token_secret = "h9jDidOLH0uzzBz6kuzqB34NJ0NorClL8QD2wmpY"
    end
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