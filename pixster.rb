require 'typhoeus'
require 'nokogiri'


response = Typhoeus.post(
  "http://picascii.com/upload.php",
  {
    body: {
      'MAX_FILE_SIZE' => '1048576',
      'quality' => '3',
      'size' => '5',
      imageupload: File.open('/Users/stuart/Desktop/220px-Nyan_cat_250px_frame.PNG',"r")
    },
    cookiefile: "./cookies",
    cookiejar: "./cookies",
    followlocation: true
  }
)

html_doc = Nokogiri::HTML(response.body)do |config|
  config.strict.nonet
end


textarea = html_doc.css("textarea").first

puts textarea.text

