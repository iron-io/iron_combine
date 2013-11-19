require 'iron_worker_ng'

iw = IronWorkerNG::Client.new

iw.schedules.list(:per_page => 100).each do |schedule|
  if schedule['code_name'] == 'enforcer'
    iw.schedules.cancel(schedule['_id'])
  end
end

iw.codes.list(:all => true).each do |code|
  if code['name'] == 'enforcer'
    iw.tasks.list(:code_name => code['name'], :queued => 1, :running => 1).each do |task|
      iw.tasks.cancel(task['_id'])
    end
  end
end

iw.codes.list(:all => true).each do |code|
  if code['name'].end_with?('::dispatcher')
    iw.tasks.list(:code_name => code['name'], :queued => 1, :running => 1).each do |task|
      iw.tasks.cancel(task['_id'])
    end
  end
end
