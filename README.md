Assuming you have worker which does some really quick job (like examples/delay.original.rb) you want to improve performance of you workers by joining several small jobs into one bigger. Make sure you have iron_worker_ng-1.0.4+ installed before you start.

1. Adjust your worker so it'll accept array of base64-encoded payloads, not just one payload. Check how it's done in the examples/delay.rb. Note, it'll continue to work if queued normally and will support array of payloads as well. Re-upload and test it.

2. Edit config.json and adjust parameters there. It should be array of hashes for each worker you want to use that way in the project with key containing worker name and some parameters:
   - `queue` - queue name which will be used to start workers instead of queueing them.
   - `chunk_size` - maximum amount of jobs to be joined to one array.
   - `concurrency` - number of dispatchers to run (start with 1 or 2, increase in case it can't handle load).

3. Upload and start it: `ruby upload.rb` and `ruby start.rb`.

4. Start queueing (or mass queueing) workers via posting to specified queue: `mq.queue('delay').post({:delay => 10}.to_json)` instead of `worker.tasks.create('delay', :delay => 10)` e.g.

5. If you update iron_combine or tweaked config, stop process via `ruby stop.rb` and upload/start again.
