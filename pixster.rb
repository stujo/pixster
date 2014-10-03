require 'typhoeus'
require 'nokogiri'

print "What file or url? : "

filename_or_url = $stdin.gets.chomp

unless filename_or_url.nil?

  puts "Processing #{filename_or_url}"

  payload  = {
    'MAX_FILE_SIZE' => '1048576',
    'quality' => '3',
    'size' => '5',
  }

  if filename_or_url.include? "://"
    payload[:url] = filename_or_url
  else
    payload[:imageupload] = File.open(filename_or_url,"r")
  end

  response = Typhoeus.post(
    "http://picascii.com/upload.php",
    {
      body: payload,
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
end
