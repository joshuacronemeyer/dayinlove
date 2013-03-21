class LoveRequest < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :original_file_url, :request
  def self.process!(mention)
    user = User.find_by_nickname(mention.from_user)
    if mention.media && !mention.media.empty?
      photo = mention.media.first
      url = photo.media_url
      new_request = self.create!(user: user, original_file_url: url, request: mention.text)
      CompositeImage.new(new_request).delay.composite!
      new_request
    end
  end
  
  def todays_message
    "#{today} #{messages[today]}"
  end

  private
  def today
    Date.today.strftime('%A')
  end

  def messages
    {"Monday" => "You can fall apart",
    "Tuesday" => "Break my heart",
    "Wednesday" => "Break my heart",
    "Thursday" => "Doesn't even start",
    "Friday" => "I'm in love",
    "Saturday" => "Wait...",
    "Sunday" => "Always comes too late"}
  end

end
