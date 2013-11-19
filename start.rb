require 'iron_worker_ng'

iw = IronWorkerNG::Client.new

iw.schedules.create('enforcer', {}, :run_every => 60)
