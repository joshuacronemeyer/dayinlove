class CreateLoveRequest < ActiveRecord::Migration
  def change
    create_table :love_requests do |t|
      t.string :request
      t.string :original_file_url
      t.string :annotated_file_url
      t.integer :user_id
    end
  end
end
