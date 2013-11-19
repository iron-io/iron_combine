require 'iron_worker_ng'

iw = IronWorkerNG::Client.new(:project_id => config[:project_id], :token => config[:token])

config[:workers].each do |worker|
  running = iw.tasks.list(:code_name => worker[0], :queued => 1, :running => 1).count

  puts "#{worker[0]}: #{running} running (concurrency #{worker[1]})"

  if running < worker[1]
    # starting just one to ensure small gap between restarts
    puts "#{worker[0]}: starting"
    iw.tasks.create(worker[0])
  end
end
