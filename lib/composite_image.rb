require 'rest-open-uri'
require 'RMagick'
include OpenURI

class CompositeImage
  def initialize(image_url, message)
    @image_url = image_url
    @message = message
  end

  def composite!
    fetch_image
    annotate_image
    store_image
  end

  def fetch_image
    dont_download_huge_images!
    @image = Tempfile.new(['dayinlove', '.jpg'], "#{Rails.root}/tmp")
    File.open(@image, 'wb') do |file|
      file << get_uri.read
    end
  end

  def annotate_image
    canvas = Magick::ImageList.new(@image.path)
    canvas.change_geometry!('500') { |cols, rows, img| img.resize!(cols, rows) }
    annotate(canvas)
    @annotated_image = Tempfile.new(['dayinlove', '.jpg'], "#{Rails.root}/tmp")
    canvas.write @annotated_image.path
  end

  def store_image
    s3 = AWS::S3.new
    b = s3.buckets[ENV['S3_BUCKET_NAME']]
    o = b.objects["#{SecureRandom.hex(10)}.jpg"]
    o.write(:file => @annotated_image.path)
    o.acl = :public_read
    delete_files
    o.public_url
  end

  private

  def get_uri
    URI.parse(@image_url)
  end

  def delete_files
    @annotated_image.close
    @annotated_image.unlink
    @image.close
    @image.unlink
  end

  def dont_download_huge_images!
    head = open(@image_url, method: :head)
    size = head.meta["content-length"]
    raise "Webserver not reporting content-length" unless size
    raise "Image too large to process." if size.to_i > 1000000
  end

  def get_font
    text = Magick::Draw.new
    text.fill = '#FFFFFF'
    text.pointsize = 65
    text.stroke = "#000000"
    text.stroke_width = 2
    text.font = "#{Rails.root}/lib/assets/fonts/PermanentMarker.ttf"
    text.gravity = ::Magick::SouthGravity
    text
  end

  def annotate(canvas)
    @message.reverse.each_with_index do |message, i|
      canvas.annotate(get_font, 0,0,0,i*50, message)
    end
  end
end
