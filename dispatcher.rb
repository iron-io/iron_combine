require 'iron_worker_ng'
require 'iron_mq'

start = Time.now

puts 'starting'

iw = IronWorkerNG::Client.new(:project_id => config[:project_id], :token => config[:token])
imq = IronMQ::Client.new(:project_id => config[:project_id], :token => config[:token])

queue = imq.queue(config[:queue])

puts "listening on queue #{config[:queue]}"

while true
  if Time.now - start >= 55 * 60
    puts 'terminating'
    break
  end

  messages = queue.get(:n => config[:chunk_size])

  puts "got #{messages.count} messages"

  if messages.count == 0
    sleep(1)
  else
    payload = messages.map { |m| Base64.encode64(m.body) }

    iw.tasks.create(config[:process_worker], :messages => payload)

    puts "queued #{config[:process_worker]} with #{payload.inspect}"

    ids = messages.map { |m| m.id }
    queue.delete_messages(ids)
  end
end

puts 'finished'
