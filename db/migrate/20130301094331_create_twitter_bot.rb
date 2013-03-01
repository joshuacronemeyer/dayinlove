class CreateTwitterBot < ActiveRecord::Migration
  def change
    create_table :twitter_bots do |table|
      table.integer  :newest_processed_mention_id
      table.timestamps
    end
  end
end
