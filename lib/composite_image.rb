require 'rest-open-uri'
require 'RMagick'
include OpenURI

class CompositeImage
  def initialize(love_request)
    @love_request = love_request
    @image_url = love_request.original_file_url
  end

  def composite!
    fetch_image
    annotate_image
    TwitterBot.tweet(@love_request, @annotated_image)
    url = store_image_in_s3_and_delete_local
    @love_request.update_attributes(annotated_file_url:url)
    url
  end

  def fetch_image
    dont_download_huge_images!
    @image = Tempfile.new(['dayinlove', '.jpg'], ensure_temp_dir_exists)
    File.open(@image, 'wb') do |file|
      file << get_uri.read
    end
  end

  def annotate_image
    canvas = Magick::ImageList.new(@image.path)
    canvas.change_geometry!('500') { |cols, rows, img| img.resize!(cols, rows) }
    annotate(canvas)
    @annotated_image = Tempfile.new(['dayinlove', '.jpg'], ensure_temp_dir_exists)
    canvas.write @annotated_image.path
  end

  def store_image_in_s3_and_delete_local
    s3 = AWS::S3.new
    b = s3.buckets[ENV['S3_BUCKET_NAME']]
    o = b.objects["#{SecureRandom.hex(10)}.jpg"]
    o.write(:file => @annotated_image.path)
    o.acl = :public_read
    delete_files
    o.public_url
  end

  private

  def ensure_temp_dir_exists
    temp_dir = Rails.root.join('tmp')
    Dir.mkdir(temp_dir) unless Dir.exists?(temp_dir)
    temp_dir
  end

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

  def get_font(message_length)
    text = Magick::Draw.new
    text.fill = '#FFFFFF'
    text.pointsize = font_size(message_length)
    text.stroke = "#000000"
    text.stroke_width = 2
    text.font = "#{Rails.root}/lib/assets/fonts/PermanentMarker.ttf"
    text.gravity = ::Magick::SouthGravity
    text
  end

  def annotate(canvas)
    message_array = [@love_request.today].concat(@love_request.messages[@love_request.today])
    message_array.reverse.each_with_index do |message, i|
      canvas.annotate(get_font(message.size), 0,0,0,i*50, message)
    end
  end

  def font_size(message_length)
    max_large_characters_that_fit_a_line = 17
    small_point_size = 55
    large_point_size = 65
    message_length > max_large_characters_that_fit_a_line ? small_point_size : large_point_size
  end
end
