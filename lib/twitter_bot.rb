class TwitterBot < ActiveRecord::Base
  attr_accessible :newest_processed_mention_id
  NUMBER_TO_PROCESS = 200

  def self.process_new_mentions
    options = {count: NUMBER_TO_PROCESS}
    options.merge!({since_id: processor.newest_processed_mention_id}) if processor.newest_processed_mention_id
    mentions_to_process = Twitter.mentions(options)
    mentions_to_process.each do |mention|
      log_message_processed(mention)
      LoveRequest.new(mention).parse.delay.perform unless should_be_ignored?(mention)
      processor.update_attributes(newest_processed_mention_id: mention.id)
    end      
  end
  
  def self.twitter_bot
    all.first || TwitterBot.create!
  end
  
  def self.invalidate_all_tweets
    mentions = Twitter.mentions({count:1})
    processor.update_attributes(newest_processed_mention_id: mentions.first.id) if mentions.first
  end
  
  private
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