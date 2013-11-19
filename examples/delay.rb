require 'base64'
require 'json'

puts "params: #{params}"

messages = nil
if params['messages']
  messages = params['messages'].map { |m| JSON.parse(Base64.decode64(m)) }
else
  messages = [{'delay' => params['delay']}]
end

puts "messages: #{messages}"

messages.each do |message|
  sleep message['delay'].to_i
end
