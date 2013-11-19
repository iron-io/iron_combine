require 'iron_worker_ng'
require 'json'

iw = IronWorkerNG::Client.new

config = JSON.parse(File.read('config.json'))

config.keys.each do |worker|
  dispatcher_config = {
    :project_id => iw.project_id,
    :token => iw.token,
    :queue => config[worker]['queue'] || worker,
    :chunk_size => config[worker]['chunk_size'],
    :process_worker => worker
  }

  code = IronWorkerNG::Code::Base.new
  code.runtime 'ruby'
  code.name "#{worker}::dispatcher"
  code.exec 'code/dispatcher.rb'
  code.gem 'iron_worker_ng'
  code.gem 'iron_mq'
  code.remote

  iw.codes.create(code, :config => dispatcher_config)
end

enforcer_config = {
  :project_id => iw.project_id,
  :token => iw.token,
  :workers => config.keys.map { |worker| ["#{worker}::dispatcher", config[worker]['concurrency']] }
}

code = IronWorkerNG::Code::Base.new
code.runtime 'ruby'
code.name 'enforcer' 
code.exec 'code/enforcer.rb'
code.gem 'iron_worker_ng'
code.remote

iw.codes.create(code, :config => enforcer_config)
