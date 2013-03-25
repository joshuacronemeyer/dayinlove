class MakeLastTweetBigint < ActiveRecord::Migration
  def change
    change_column :twitter_bots, :newest_processed_mention_id, :bigint
  end
end
