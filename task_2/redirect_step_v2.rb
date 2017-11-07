require 'net/http'
require 'uri'

uri = URI.parse("https://onetwotrip.com")
response = Net::HTTP.get_response(uri)

if response.get_fields('Location').eql?(["https://www.onetwotrip.com/"]) && response.code.to_i == 301
  puts "ОК"
else
  puts response.get_fields('Location')
  puts response.code
end
