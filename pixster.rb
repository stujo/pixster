require 'typhoeus'
require 'nokogiri'
require 'rmagick'


class Pixster
  attr_reader :ascii_text

  def run
    get_filename
    save_resized_image
    call_picascii
    delete_tmp_file
    read_html_response
    extract_ascii_text
  end

  private

  def get_filename
    @filename_or_url = ARGV[0]

    unless @filename_or_url
      print "What file or url? : "
      @filename_or_url = $stdin.gets.chomp
    end
  end

  def save_resized_image
    puts "Processing #{@filename_or_url}"
    @tmp_file = Tempfile.new(['pixster', '.jpg']).path
    img = Magick::Image::read(@filename_or_url)[0]
    puts "Original image is #{img.columns}x#{img.rows} pixels"
    img200x200 = img.resize_to_fit(200,200)
    puts "Resized image is #{img200x200.columns}x#{img200x200.rows} pixels"
    img200x200.write(@tmp_file)
  end

  def payload
    {
      'MAX_FILE_SIZE' => '1048576',
      'quality' => '3',
      'size' => '5',
      'imageupload' => File.open(@tmp_file,"r")
    }
  end

  def call_picascii
    @response = Typhoeus.post(
      "http://picascii.com/upload.php",
      {
        body: payload,
        cookiefile: "./cookies",
        cookiejar: "./cookies",
        followlocation: true
      }
    ).body
  end

  def delete_tmp_file
    File.delete(@tmp_file)
  end

  def read_html_response
    @html_doc = Nokogiri::HTML(@response)do |config|
      config.strict.nonet
    end
  end

  def extract_ascii_text
    textarea = @html_doc.css("textarea").first
    @ascii_text = textarea.text
  end
end

pixster = Pixster.new

pixster.run

puts pixster.ascii_text
