require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'faraday-cookie_jar'

filename = '/Users/stuart/Desktop/220px-Nyan_cat_250px_frame.PNG'

conn = Faraday.new(:url => 'http://picascii.com') do |faraday|
  faraday.use FaradayMiddleware::FollowRedirects, limit: 3

  faraday.request  :multipart
  faraday.use Faraday::Response::Logger
  faraday.use :cookie_jar
  faraday.request :url_encoded


  faraday.adapter  :net_http
end


# response = conn.post '/upload.php' do |req|
#   payload = {
#     'MAX_FILE_SIZE' => '1048576',
#     'quality' => '3',
#     'size' => '5',
#     'url' => 'http://upload.wikimedia.org/wikipedia/en/thumb/e/ed/Nyan_cat_250px_frame.PNG/220px-Nyan_cat_250px_frame.PNG',
# #    'imageupload' =>  Faraday::UploadIO.new(filename, 'image/png'),
#   }
#   req.body = payload
# end

payload = {'MAX_FILE_SIZE' => '1048576', 'imageupload' =>  Faraday::UploadIO.new(filename, 'image/png')}

response = conn.post '/upload.php', payload

puts response.body
