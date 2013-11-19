require 'base64'
require 'json'

puts "params: #{params}"

if params['messages']
  messages = params['messages'].map { |m| JSON.parse(Base64.decode64(m)) }
else
  messages = [params]
end

puts "messages: #{messages}"

messages.each do |message|
  sleep message['delay'].to_i
end
