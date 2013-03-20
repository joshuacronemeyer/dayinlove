class LoveRequest
  def initialize(mention)
    @mention = mention
  end
  
  def process!
    if @mention.media && !@mention.media.empty?
      photo = @mention.media.first
      url = photo.media_url
      CompositeImage.new(url, [today, messages[today]]).delay.composite!
    end
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
