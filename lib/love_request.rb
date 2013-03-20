class LoveRequest
  def initialize(mention)
    @mention = mention
  end
  
  def process!
    if @mention.media && !@mention.media.empty?
      photo = @mention.media.first
      url = photo.media_url
      CompositeImage.new(url, ["Friday", "I'm in love"]).delay.composite!
    end
  end

end
