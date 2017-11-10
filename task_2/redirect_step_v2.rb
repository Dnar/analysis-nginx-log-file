require 'net/http'
require 'uri'

uri = URI.parse("https://__.com")
response = Net::HTTP.get_response(uri)

if response.get_fields('Location').eql?(["https://www.__.com/"]) && response.code.to_i == 301
  puts "ОК"
else
  puts response.get_fields('Location')
  puts response.code
end
