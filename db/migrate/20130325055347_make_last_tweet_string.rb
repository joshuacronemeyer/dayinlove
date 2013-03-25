class MakeLastTweetString < ActiveRecord::Migration
  def change
    change_column :twitter_bots, :newest_processed_mention_id, :string
  end
end
